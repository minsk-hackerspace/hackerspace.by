require 'rails_helper'

RSpec.describe "admin/payments/index", type: :view do
  before(:each) do
    assign(:payments, [
      Payment.create!(
        :amount => "9.99",
        :payment_type => "donation",
        :payment_form => "cash",
        :paid_at => Time.now
      ),
      Payment.create!(
        :amount => "9.99",
        :payment_type => "donation",
        :payment_form => "cash",
        :paid_at => Time.now
      )
    ])
  end

  pending "Implement admin/payments/index view test"

#  it "renders a list of payments" do
#    render

#    assert_select "tr>td", :text => "9.99".to_s, :count => 2
#    assert_select "tr>td", :text => "donation".to_s, :count => 2
#    assert_select "tr>td", :text => "cash".to_s, :count => 2
#  end
end
