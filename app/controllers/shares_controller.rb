class SharesController < InheritedResources::Base
  respond_to :js, :only => :update_data
  custom_actions :member => :update_data
  before_filter :get_share, :only => [:show, :update_data]
  
  # def collection
  #   @shares ||= Share.all
  # end
  
  def show
    @values = @share.values.order([:date,:desc])
    show!
  end
  
  def update_data
    @result = @share.get_trades_by_api
  end
  
  private
  
  def get_share
    @share ||= Share.find(params[:id])
  end
  
end
