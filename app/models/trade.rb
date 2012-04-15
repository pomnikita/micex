class Trade
  include MicexApi
  include Mongoid::Document
  include Mongoid::Timestamps

  FIELDS = ["TRADENO","TRADETIME","BOARDID","SECID","PRICE","QUANTITY","BUYSELL"]

  field :tradeno, :type => Integer
  field :tradetime, :type => Time
  field :boardid, :type => String
  field :secid, :type => String
  field :price, :type => Float
  field :quantity, :type => Integer
  field :buysell, :type => String

  index :tradeno
  index :tradetime

  belongs_to :share
  
  scope :for_share, ->(share_id) { where(:share_id => share_id) }
  scope :for_date, ->(date) { where(:tradetime.gt => date.beginning_of_day, :tradetime.lt => date.end_of_day) }
  scope :for_period, ->(from,to) {where(:tradetime.gt => from.beginning_of_day, :tradetime.lt => to.end_of_day)}
  scope :for_hour, ->(time) { where(:tradetime.gt => time, :tradetime.lt => time + 1.hour)}
  
  def buysell_sign
    buy? ? 1 : -1
  end
  
  def buy?
    buysell == "B"
  end
  
  def net_value
    buysell_sign * (price * quantity)
  end
  
  class << self
    def count_stats_for(share, date, kind)
      date ||= Date.today
      kind ||= TradeStat::KINDS[:buysell]
      case kind
      when TradeStat::KINDS[:buysell]
        buysell_stats_for(share, date)
      when TradeStat::KINDS[:firstlast]
        firstlast_stats_for(share, date)
      end
    end
        
    def firstlast_stats_for(share, date)
      tradesScope = self.where(:share_id => share.id).for_date(date).order_by([:tradeno, :asc]).only(:tradetime, :buysell, :price, :quantity).all
      return nil unless tradesScope.any?
      start_value = tradesScope.first.net_value
      end_value = 0
      tradesScope.all.group_by{|trade| trade.tradetime.hour}.each do |hour, trades|
        trades.each do |trade|
          end_value += trade.net_value.round
        end
      end
      return [start_value, end_value]
    end
    
    def get_last_value(share, date)
      TradeStat.collection.find(
        {:share_id => share.id, :date => {"$lt" => date.utc}, :kind => TradeStat::KINDS[:firstlast]}, 
        {:fields => 'stat_data', :sort => ['date','desc']}
      ).sum{|ts| ts['stat_data'][1]}
    rescue 0
    end
    
    def prev_day_for(date = Date.today)
      prev_day = date.monday? ? date - 3.days : date.yesterday
    end
    
    def connection
      @connection ||= Mongoid::Config.database['trades']
    end
  end
end
