class ChangeMonthlyPaymentDefaultInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :monthly_payment_amount, 70.0
  end
end
