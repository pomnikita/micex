class ChartsController < ApplicationController
  before_filter :get_parent, :only => [:update_charts, :buysell, :ohlc]
  before_filter :get_date, :only => :buysell
  include Charts
  
  def buysell
    charts_data = Charts::Data.new('buysell', @parent, @date)
    @values, @prices = charts_data.get_prices_and_values
  end
  
  def ohlc
    @prices, @values = Charts::Candles.new(@parent).get_candles_and_values
  end
  
  def update_charts
    TradeStat.create_stat_for(@parent, :kind => "firstlast")
    TradeStat.create_stat_for(@parent, :kind => "buysell")
  end
  
  private
  def get_parent
    @parent ||= Share.find(params[:share_id])
  end
  
  def get_date
    @date ||= params[:date] ? Date.parse(params[:date]) : nil
  end
end
