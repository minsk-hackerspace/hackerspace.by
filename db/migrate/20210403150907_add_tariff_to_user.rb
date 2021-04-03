class AddTariffToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :tariff, foreign_key: true

    users = User.all
    users.each do |u|
      t = Tariff.find_or_create_by(monthly_price: u.monthly_payment_amount) do |t|
        price = u.monthly_payment_amount

        # Remove .0 if amount is round
        price = price.to_i if price.to_i == price

        t.ref_name="custom_#{price}"
        t.name="Custom #{price}"
        t.description="Пользовательский тариф, #{price} р./мес."
        t.access_allowed = true
      end

      u.tariff = t
      u.save
    end
  end
end
