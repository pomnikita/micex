class MonthlySummary
  include Mongoid::Document
  include Mongoid::Timestamps
  include Charts
  
  field :share_id, :type => String
  field :values,   :type => Array
  field :month,    :type => String
  field :year,     :type => String
  field :prices,   :type => Array
  
  belongs_to :share
  
  def self.generate_for(share, month=1, year=2012)
    from, to = parse_dates(month, year)
    prices, values = Charts::Data.new(share, from, to).get_prices_and_values
    return if prices.blank? or values.blank?
    
    new_value = MonthlySummary.find_or_initialize_by(:share_id => share.id, :month => month.to_s, :year => year.to_s)
    new_value.values = values
    new_value.prices = prices
    return new_value.save
  end
  
  def self.parse_dates(month, year)
    month = month.to_s.downcase
    year  = year.to_s.downcase
    date  = [year, month, '1'].join('-')
    from  = Date.parse(date).beginning_of_month
    to    = Date.parse(date).end_of_month
    [from, to]
  end
  
end


