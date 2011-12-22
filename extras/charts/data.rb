module Charts
  MAX_SIZE = 60000
  class Data
    def initialize(kind, share, date)
      @date = date
      @trade_stat = TradeStat.where(:kind => kind, :share_id => share.id)
      @prices = []
      @values = []
    end
  
    def collect_data_from(data)
      data.keys.map(&:to_i).sort.each do |key|
        data[key.to_s].each do |arr|
          @values << arr[0]
          @prices << arr[1]
        end
      end
    end
    
    def truncate_data
      [@values, @prices].map do |ar|
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
      if @date
        trade_stat = @trade_stat.where(:date => @date).last
        data = trade_stat ? trade_stat.stat_data : {}
        collect_data_from(data)
      else
        trade_stat = @trade_stat.order([:date, :asc]).all
        trade_stat.each do |ts|
          collect_data_from(ts.stat_data)
        end
      end
      return truncate_data
    end
  end
end