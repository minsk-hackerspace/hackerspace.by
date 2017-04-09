class CreateEripTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :erip_transactions do |t|
      t.string :status
      t.string :message
      t.string :type
      t.string :transaction_id
      t.string :uid
      t.string :order_id
      t.decimal :amount
      t.string :currency
      t.string :description
      t.string :tracking_id
      t.datetime :transaction_created_at
      t.datetime :expired_at
      t.datetime :paid_at
      t.boolean :test
      t.string :payment_method_type
      t.json :billing_address
      t.json :customer
      t.json :payment
      t.json :erip

      t.timestamps
    end
  end
end
