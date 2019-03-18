class AdminController < ApplicationController
#  before_action :authenticate_user!
  authorize_resource :class => false

end
