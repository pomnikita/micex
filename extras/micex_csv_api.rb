require 'csv'

module MicexCsvApi
  
  def get_trades_from_csv(file)
    time1 = Time.now
    collection = []
    CSV.foreach(file, :col_sep => ';') do |row|
      collection << columns_from_row(row) if share_row?(row)
    end
    Trade.collection.insert(collection)
    time2 = Time.now
    puts "Timeline: #{time2-time1}"
    Rails.logger.info "Timeline: #{time2-time1}"
  end
  
  def share_row?(row)
    row[3].downcase == self.ticker.downcase
  end
  
  def columns_from_row(row)
    {}.tap do |item|
      item['tradeno']    = row[0]
      item['tradetime']  = Time.parse([row[1..2]].join(' '))
      item['created_at'] = Time.now
      item['share_id']   = row[3].downcase
      item['secid']      = row[3]
      item['boardid']    = row[4]
      item['price']      = row[5].sub(',','.').to_f
      item['quantity']   = row[6].to_i
      item['buysell']    = row[9]
    end
  end
end