class Value
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :first, :type => Float
  field :last, :type => Float
  field :share_id, :type => String
  field :date, :type => Date
  field :values, :type => Array

  field :kind, :type => String
  field :month, :type => String
  field :year, :type => String
  
  belongs_to :share
  scope :for_dates, ->(date1, date2) { where(:date.gte => date1, :date.lte => date2) }
  
  index :date  
  
  class << self    
    
    def daily_values_for(share, date = Date.today)
      tradesScope = Trade.for_period(date, date).for_share(share.id).order_by(['tradetime', 'asc'])
      first_value = Value.get_last_value(share, date)
      return nil unless first_value
      values = [first_value]
      tradesScope.each do |trade|
        values << values.last + trade.net_value
      end
      
      new_value = Value.find_or_initialize_by(:share_id => share.id, :date => date)
      new_value.values = values
      return new_value.save
    end
    
    def get_last_value(share, date)
      self.where({:date.lt => date, :share_id => share.id}).order_by(['date', 'asc']).last.values.last
      rescue nil
    end
    
    def connection
      @connection ||= Mongoid::Config.database['values']
    end
  end
end