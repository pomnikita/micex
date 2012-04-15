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
      months = months_in_period
      prices, values = [], []
      if months.any?
        prices = @share.get_prices_for_period(@from, @from.end_of_month) unless months.include?([@from.month, @from.year])
        values = @share.get_values_for_period(@from, @from.end_of_month) unless months.include?([@from.month, @from.year])
        months.each do |month|
          prices << MonthlySummary.where(:month => month[0].to_s, :year => month[1].to_s).last.prices
          values << MonthlySummary.where(:month => month[0].to_s, :year => month[1].to_s).last.values
        end
        prices << @share.get_prices_for_period(@to.beginning_of_month, @to) unless months.include?([@to.month, @to.year])
        values << @share.get_values_for_period(@to.beginning_of_month, @to) unless months.include?([@to.month, @to.year])
      else
        prices = @share.get_prices_for_period(@from, @to)
        values = @share.get_values_for_period(@from, @to)
      end
      @prices = prices.flatten
      @values = values.flatten
    end
    
    # Refactor or die
    def months_in_period
      months = []
      if @from.day == 1 && @from.end_of_month <= @to
        months << [@from.month, @from.year]
      end
      start_point = @from.end_of_month
      end_point   = @to.beginning_of_month  
      while start_point + 1.day < end_point
        start_point >>= 1
        months << [start_point.month, start_point.year]
      end
      if @to.day == @to.end_of_month.day && @to.beginning_of_month > @from
        months << [@to.month, @to.year]
      end
      months
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
      # size = [@values.size, @prices.size].min
      # iter = size / MAX_SIZE.to_f
      # indexes = if iter > 2
      #   (0..size-1).select{|ind| ind % iter.round == 0}
      # elsif iter > 1
      #   (0..size-1).select{|ind| ind % 2 != 0}
      # else
      #   (0..size-1)
      # end
      # # debugger
      # prs  = indexes.map { |i| @prices[i] }
      # vals = indexes.map { |i| @values[i] }
      # [prs, vals]
    end
    
    def get_prices_and_values
      collect_data
      return truncate_data
    end
  end
end