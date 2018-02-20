class CreatePayments < ActiveRecord::Migration[5.0]
  
  def get_payment_type(et)
    case et.erip['service_no']
    when 248
      'membership'
    when 249
      'donation'
    end
  end

  def up
    add_column :users, :monthly_payment_amount, :float, default: 50

    create_table :payments do |t|
      t.belongs_to :user
      t.belongs_to :erip_transaction
      t.datetime :paid_at, null: false
      t.decimal :amount, null: false, default: 0
      t.date :start_date
      t.date :end_date
      t.string :payment_type, null: false
      t.string :payment_form, null: false
      t.string :description

      t.timestamps
    end

    EripTransaction.all.each do |et|
      next unless et.status == 'successful'

      start_date = end_date = nil
      u = nil
      if et.erip['service_no'] == 248
        start_date = et.paid_at
        end_date = et.paid_at + 1.month
        begin
          u = User.find(et.erip['account_number'])
        rescue
          u = nil
        end
      end
      p = Payment.create(erip_transaction: et,
                         amount: et.amount,
                         paid_at: et.paid_at,
                         payment_type: get_payment_type(et),
                         payment_form: 'erip',
                         start_date: start_date,
                         end_date: end_date,
                         user: u)
      STDERR.puts "Payment created: #{p.inspect} #{p.errors.empty? ? '' : p.errors.inspect}"
    end 
  end

  def down
    drop_table :payments
    remove_column :users, :monthly_payment_amount
  end

end
