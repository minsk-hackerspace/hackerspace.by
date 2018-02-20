require 'rails_helper'

RSpec.describe "admin/payments/edit", type: :view do
  before(:each) do
    @payment = assign(:payment, Payment.create!(
      :amount => "9.99",
      :payment_type => "donation",
      :payment_form => "cash",
      :paid_at => Time.now
    ))
  end

  it "renders the edit payment form" do
    render

    assert_select "form[action=?][method=?]", admin_payment_path(@payment), "post" do

      assert_select "input#payment_amount[name=?]", "payment[amount]"

 #     assert_select "input#payment_payment_type[name=?]", "payment[payment_type]"

 #     assert_select "input#payment_payment_form[name=?]", "payment[payment_form]"
    end
  end
end
