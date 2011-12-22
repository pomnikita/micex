class Candle
  include Mongoid::Document
  field :date,       :type => Date
  field :period,     :type => String
  field :start_time, :type => Time
  field :end_time, :type => Time
  field :open,     :type => Float
  field :high, :type => Float
  field :low,  :type => Float
  field :close,  :type => Float
  field :volume, :type => Integer
  field :value,    :type => Integer
  field :share_id, :type => String
  
  belongs_to :share
  
  scope :for_period, ->(period) { where(:period => period) }
  scope :for_date, ->(date) {where(:date => date)}
  scope :for_share, ->(share) { where(:share_id => share.id) }
  scope :default_sort, order_by([:start_time, :asc])
  
  PERIODS = ['1hour', '5min', '1day']
  
  class << self
    def generate_hour_candles_for(share, date, hour)
      time = date + hour.hours
      trades = Trade.for_share(share.id).for_hour(time)
      return unless trades.any?
      candle = Candle.new(:period => '1hour', :date => date, :start_time => time, :end_time => time + 1.hour, :share_id => share.id )
      candle.open = trades.first.price
      candle.close = trades.last.price
      candle.high = trades.max(:price)
      candle.low = trades.min(:price)
      candle.volume = trades.sum(:quantity).to_i
      candle.value = trades.all.to_a.sum(&:net_value).to_i
      candle.save
    end
    
    def generate_candles_for(share, date, kind='1hour')
      (10..18).each do |hour|
        self.generate_hour_candles_for(share, date, hour)
      end
    end

    #output: OHLC
    def get_candles_for_chart(share, period='1hour')
      output = []
      case period
      when '1hour'
        Candle.for_share(share).for_period(period).default_sort.all.each do |candle|
          output << [(candle.start_time + 4.hours).to_i*1000, candle.open, candle.high, candle.low, candle.close]
        end
      end
      output
    end
    
  end
end
