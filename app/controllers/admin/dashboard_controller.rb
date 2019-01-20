class Admin::DashboardController < AdminController
  authorize_resource :class => false
  def index
  end
end
