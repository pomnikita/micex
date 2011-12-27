class ChartsController < ApplicationController
  before_filter :get_parent, :only => [:update_charts, :buysell, :ohlc]
  before_filter :get_period, :only => :buysell
  include Charts
  
  def buysell
    @prices, @values = Charts::Data.new(@parent, @from, @to).get_prices_and_values
  end
  
  def ohlc
    @prices, @values = Charts::Candles.new(@parent).get_candles_and_values
  end
  
  # def update_charts
  #   TradeStat.create_stat_for(@parent, :kind => "firstlast")
  #   TradeStat.create_stat_for(@parent, :kind => "buysell")
  # end
  
  private
  def get_parent
    @parent ||= Share.find(params[:share_id])
  end
  
  def get_period
    @from = params[:from] ? Date.parse(params[:from]) : Date.today
    @to   = params[:to]   ? Date.parse(params[:to])   : Date.today
  end
end
