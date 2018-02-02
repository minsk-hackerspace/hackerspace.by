require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:admin_user) }

  before do
    sign_in user
  end

end
