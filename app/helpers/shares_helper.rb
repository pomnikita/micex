module SharesHelper
  def chart_from_micex_for(share, date1, date2, period)
    micex_url = "http://www.micex.ru/cs_compat?"
    query_params = {
      :secid => share.ticker,
      :timeline => date1.strftime('%Y.%m.%d')+'-'+date2.strftime('%Y.%m.%d'),
      :template => 'micextest',
      :trade_engine => 'stock',
      :market => 'shares',
      :linetype => 'candles',
      :board_group_id => 6,
      :interval => {'week' => 60, 'day' => 10, 'month' => 24, 'quarter' => 24, 'year' => 7}[period],
      :period => {'week' => '-7d', 'day' => '-1d', 'month' => '-1M', 'quarter' => '-3M', 'year' => '-1y'}[period],
      :lang => 'ru'
    }
    
    image_tag micex_url + query_params.to_query, :width => 700
  end
end