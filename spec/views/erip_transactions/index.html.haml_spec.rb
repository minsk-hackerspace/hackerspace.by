require 'rails_helper'

RSpec.describe "erip_transactions/index", type: :view do
  before(:each) do
    assign(:erip_transactions, [
      EripTransaction.create!(
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
      ),
      EripTransaction.create!(
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
      )
    ])
  end

  it "renders a list of erip_transactions" do
    render
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Message".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Transaction".to_s, :count => 2
    assert_select "tr>td", :text => "Uid".to_s, :count => 2
    assert_select "tr>td", :text => "Order".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Currency".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Tracking".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Payment Method Type".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
