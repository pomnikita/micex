module Charts
  class Candles
    def initialize(share)
      @candles = Candle.for_share(share).for_period('1hour').default_sort
      @share = share
    end
    
    def get_candles_and_values
      candles_output = []
      values_output = []
      value = 0
      @candles.each do |candle|
        candles_output << [(candle.start_time + 4.hours).to_i*1000, candle.open, candle.high, candle.low, candle.close]
        value += candle.value
        values_output << [(candle.start_time + 4.hours).to_i*1000, value]
      end
      return candles_output, values_output
    end
    
  end
end