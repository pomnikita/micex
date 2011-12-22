class TradeStat
  include Mongoid::Document
  KINDS = {:buysell => "buysell", :firstlast => "firstlast"}
  
  field :kind, :type => String
  field :date, :type => Date
  field :stat_data, :type => Hash
  field :prices, :type => Array
  field :values, :type => Array
  
  index :date
  
  belongs_to :share
  
  validates_presence_of :stat_data
  
  scope :buysell,   where(kind: KINDS[:buysell])
  scope :firstlast, where(kind: KINDS[:firstlast])
  
  def delete_old_records(share, date, kind)
    TradeStat.where(:share_id => share.id, :date => date, :kind => kind).not_in(_id: [self._id]).delete_all
    true
  end
  
  
  class << self
    def create_stat_for(share, options = {})
      kind = options[:kind] ||= KINDS[:buysell]
      date = options[:date] ||= Date.today
      stat_data = KINDS.values.include?(kind) ? Trade.count_stats_for(share, date, kind) : nil
      return nil unless stat_data
      trade_stat = self.find_or_initialize_by(:share_id => share.id, :date => date, :kind => kind)
      trade_stat.stat_data = stat_data
      return trade_stat.save
    end

    # def normalize_stat(data)
    #   new_data = {}
    #   data.each do |k,v|
    #     array = v
    #     values = v.map{|va| va[0]}
    #     prices = v.map{|va| va[1]}
    #     delta = [values.max - values.min, (prices.max-prices.min).abs]
    #     values2 = values.map{|v| (v*delta[1]/delta[0]).round(2)}
    #     firstVal2 = values2.first
    #     values3 = values2.map{|v| v + prices.first - firstVal2}
    #     new_data[k] = []
    #     prices.each_with_index do |price, i|
    #       new_data[k] << [values3[i], price]
    #     end
    #   end
    #   new_data
    # end    
  end  
end