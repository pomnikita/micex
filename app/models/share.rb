class Share
  include MicexApi  
  include Mongoid::Document
  field :ticker, :type => String
  field :board, :type => String
  key :ticker
  has_many :candles
  has_many :trades
  has_many :trade_stats
  
  def get_trades_by_api
    self.get_trades
  end
  
  
  class << self
  end
end
