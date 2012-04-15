class SharesController < InheritedResources::Base
  actions :show
  respond_to :js, :only => :update_data
  custom_actions :member => :update_data
  # before_filter :get_share, :only => [:show, :update_data]
  before_filter :get_values, :only => :show
  
  def update_data
    Value.daily_values_for(resource) if resource.get_trades_by_api
  end
  
  def update_monthly_values
    result = MonthlySummary.generate_for(resource, Date.today.month, Date.today.year)
    message = result ? "Updates" : "Error"
    redirect_to resource, :flash => {:notice => message}
  end
  
  private

  def get_values
    @values = resource.values.order([:date,:desc])
  end
end
