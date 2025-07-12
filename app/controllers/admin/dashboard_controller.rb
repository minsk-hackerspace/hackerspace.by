# frozen_string_literal: true

module Admin
  class DashboardController < AdminController
    authorize_resource class: false
    def index; end
  end
end
