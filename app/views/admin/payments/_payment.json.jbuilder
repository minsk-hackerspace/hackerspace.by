json.extract! payment, :id, :user_id, :erip_transaction_id, :paid_at, :amount, :start_date, :end_date, :payment_type, :payment_form, :created_at, :updated_at
json.url admin_payment_url(payment, format: :json)
