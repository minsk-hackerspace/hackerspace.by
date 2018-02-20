require 'rails_helper'

RSpec.describe "admin/payments/show", type: :view do
  before(:each) do
    @payment = assign(:payment, Payment.create!(
      :amount => "9.99",
      :payment_type => "donation",
      :payment_form => "cash",
      :paid_at => Time.now
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/donation/)
    expect(rendered).to match(/cash/)
  end
end
