require "net/http"
module MicexApi
  module ClassMethods
  end

  module InstanceMethods
    
    def get_trades_from(start_num)
      request_url = 
        "http://www.micex.ru/iss/engines/stock/markets/shares/boards/#{self.board}/securities/#{self.ticker}/trades.json?trades.columns=#{Trade::FIELDS.join(',')}&start=#{start_num}"
      response = Net::HTTP.get_response(URI.parse(request_url))
      time1 = Time.now
      if response.code == "200"
        body = JSON.parse(response.body)
        if body['trades']['data'].size == 0
          Rails.logger.info("Less data")
          return  nil
        end
        collection = []
        body['trades']['data'].each do |row|
          item = {}.tap do |item|
            Trade::FIELDS.each_with_index do |attribute, ind|
              item[attribute.downcase] = row[ind]
            end
            item['tradetime'] = Time.parse(item['tradetime'])
            item['created_at'] = Time.now
            item['share_id'] = self.id
          end
          collection << item
        end
        trade = Trade.collection.insert(collection)
        time2 = Time.now
        puts "Timeline: #{time2-time1}"
        Rails.logger.info "Timeline: #{time2-time1}"
        return true
      else
        Rails.logger.info "Response: #{response}"
        return true
      end
    end
    
    def get_num_trades
      request_url = 
        "http://www.micex.ru/iss/engines/stock/markets/shares/boards/#{self.board}/securities/#{self.ticker}.json?marketdata.columns=NUMTRADES&iss.only=marketdata"
      response = Net::HTTP.get_response(URI.parse(request_url))
      if response.code == "200"
        body = JSON.parse(response.body)
        return body['marketdata']['data'].to_s.gsub(Regexp.new(/[\[\]]/),'').to_i
      else
        return 0
      end
    end
    
    def get_trades
      Rails.logger.info "Getting trades"
      start = 
        Trade.collection.find(
          {"tradetime" => {"$gt" => Time.now.beginning_of_day}, "share_id" => self.id}, 
          {:hint => "tradetime_-1"}
        ).count
      numtrades = get_num_trades
      return nil if numtrades == 0
      remain_trades = numtrades - start
      (0..remain_trades/5000).each do |i|
        self.get_trades_from(start + 5000*i)
      end
    end
  end

  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end
end