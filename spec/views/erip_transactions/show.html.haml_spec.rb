require 'rails_helper'

RSpec.describe "erip_transactions/show", type: :view do
  before(:each) do
    @erip_transaction = assign(:erip_transaction, EripTransaction.create!(
      :status => "Status",
      :message => "Message",
      :type => "Type",
      :transaction_id => "Transaction",
      :uid => "Uid",
      :order_id => "Order",
      :amount => "9.99",
      :currency => "Currency",
      :description => "Description",
      :tracking_id => "Tracking",
      :test => false,
      :payment_method_type => "Payment Method Type",
      :billing_address => "",
      :customer => "",
      :payment => "",
      :erip => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/Message/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Transaction/)
    expect(rendered).to match(/Uid/)
    expect(rendered).to match(/Order/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Currency/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Tracking/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Payment Method Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
