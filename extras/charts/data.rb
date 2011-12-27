module Charts
  MAX_SIZE = 60000
  class Data
    def initialize(share, from, to)
      @from = from
      @to = to
      @share = share
      @prices = []
      @values = []
    end
  
    def collect_data
      @prices = @share.get_prices_for_period(@from, @to)
      @values = @share.get_values_for_period(@from, @to)
    end
    
    def truncate_data
      [@prices, @values].map do |ar|
        if (iter = ar.size / MAX_SIZE.to_f) > 2
          (0..ar.size-1).select{|ind| ind % iter.round == 0}.map{|ind| ar[ind]}
        elsif iter > 1
          (0..ar.size-1).select{|ind| ind % 2 != 0}.map{|ind| ar[ind]}
        else
          ar
        end
      end
    end
    
    def get_prices_and_values
      collect_data
      return truncate_data
    end
  end
end