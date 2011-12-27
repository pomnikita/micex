class Share
  include MicexApi  
  include Mongoid::Document
  field :ticker, :type => String
  field :board, :type => String
  key :ticker
  has_many :candles
  has_many :trades
  has_many :trade_stats
  has_many :values
  
  def get_trades_by_api
    self.get_trades
  end
  
  def get_values_for_period(date1=Time.now, date2=Time.now)
    # tradesScope = Trade.for_period(date1,date2).for_share(self.id).order_by(['tradetime', 'asc'])
    valuesScope = Value.for_dates(date1, date2).order(['date', 'asc'])
    values = valuesScope.to_a.sum &:values
    # tradesScope = 
    #   Trade.connection.find(
    #     {:tradetime => {"$gt" => date1.beginning_of_day.utc, "$lt" => date2.end_of_day.utc}, :share_id => self.id}, 
    #     {:fields => ['price','tradetime','buysell','quantity'], :hint => {tradetime: 1}}
    #   )
    # values = [Value.get_last_value(self, date1)]
    # tradesScope.each do |trade|
    #   values << values.last + trade.net_value
    # end
    return values
  end
  
  def get_prices_for_period(date1=Time.now, date2=Time.now)
    tradesScope = 
      Trade.connection.find(
        {:tradetime => {"$gt" => date1.beginning_of_day.utc, "$lt" => date2.end_of_day.utc}, :share_id => self.id}, 
        {:fields => ['price'], :hint => {tradetime: 1}}
      )
    
    return tradesScope.map{|trade| trade['price']}
  end
end
