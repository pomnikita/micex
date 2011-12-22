require 'will_paginate/array'
class TradesController < InheritedResources::Base
  belongs_to :share
  
  def index
    unless params[:date]
      redirect_to share_trades_path(parent, :date => Date.today)
    end
    @trades = collection
  end
  
  def new
    @trade = parent.trades.build(:secid => parent.ticker)
  end
  
  protected
  def collection
    @date ||= params[:date] ? Date.parse(params[:date]) : Date.today 
    @trades ||= end_of_association_chain.for_date(@date).order_by([:tradeno, :asc]).paginate(:page => params[:page], :per_page => 100)
  end
end
