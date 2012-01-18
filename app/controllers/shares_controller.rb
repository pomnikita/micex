class SharesController < InheritedResources::Base
  actions :show
  respond_to :js, :only => :update_data
  custom_actions :member => :update_data
  # before_filter :get_share, :only => [:show, :update_data]
  before_filter :get_values, :only => :show
  
  # def collection
  #   @shares ||= Share.all
  # end
  
  # def show
  #   @values = @share.values.order([:date,:desc])
  #   show!
  # end
  
  def update_data
    Value.daily_values_for(resource) if resource.get_trades_by_api
  end
  
  private

  def get_values
    @values = resource.values.order([:date,:desc])
  end
  # 
  # def get_share
  #   @share ||= Share.find(params[:id])
  # end
  
end
