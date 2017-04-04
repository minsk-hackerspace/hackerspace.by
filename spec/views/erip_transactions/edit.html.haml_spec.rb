require 'rails_helper'

RSpec.describe "erip_transactions/edit", type: :view do
  before(:each) do
    @erip_transaction = assign(:erip_transaction, EripTransaction.create!(
      :status => "MyString",
      :message => "MyString",
      :type => "",
      :transaction_id => "MyString",
      :uid => "MyString",
      :order_id => "MyString",
      :amount => "9.99",
      :currency => "MyString",
      :description => "MyString",
      :tracking_id => "MyString",
      :test => false,
      :payment_method_type => "MyString",
      :billing_address => "",
      :customer => "",
      :payment => "",
      :erip => ""
    ))
  end

  it "renders the edit erip_transaction form" do
    render

    assert_select "form[action=?][method=?]", erip_transaction_path(@erip_transaction), "post" do

      assert_select "input#erip_transaction_status[name=?]", "erip_transaction[status]"

      assert_select "input#erip_transaction_message[name=?]", "erip_transaction[message]"

      assert_select "input#erip_transaction_type[name=?]", "erip_transaction[type]"

      assert_select "input#erip_transaction_transaction_id[name=?]", "erip_transaction[transaction_id]"

      assert_select "input#erip_transaction_uid[name=?]", "erip_transaction[uid]"

      assert_select "input#erip_transaction_order_id[name=?]", "erip_transaction[order_id]"

      assert_select "input#erip_transaction_amount[name=?]", "erip_transaction[amount]"

      assert_select "input#erip_transaction_currency[name=?]", "erip_transaction[currency]"

      assert_select "input#erip_transaction_description[name=?]", "erip_transaction[description]"

      assert_select "input#erip_transaction_tracking_id[name=?]", "erip_transaction[tracking_id]"

      assert_select "input#erip_transaction_test[name=?]", "erip_transaction[test]"

      assert_select "input#erip_transaction_payment_method_type[name=?]", "erip_transaction[payment_method_type]"

      assert_select "input#erip_transaction_billing_address[name=?]", "erip_transaction[billing_address]"

      assert_select "input#erip_transaction_customer[name=?]", "erip_transaction[customer]"

      assert_select "input#erip_transaction_payment[name=?]", "erip_transaction[payment]"

      assert_select "input#erip_transaction_erip[name=?]", "erip_transaction[erip]"
    end
  end
end
