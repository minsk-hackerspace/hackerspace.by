require 'rails_helper'

RSpec.describe "admin/payments/new", type: :view do
  before(:each) do
    assign(:payment, Payment.new(
      :amount => "9.99",
      :payment_type => "donation",
      :payment_form => "cash"
    ))
  end

  it "renders new payment form" do
    render

    assert_select "form[action=?][method=?]", admin_payments_path, "post" do

      assert_select "input#payment_amount[name=?]", "payment[amount]"

#      assert_select "input#payment_payment_type[name=?]", "payment[payment_type]"

#      assert_select "input#payment_payment_form[name=?]", "payment[payment_form]"
    end
  end
end
