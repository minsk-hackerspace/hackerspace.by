class AddColumnPaidUntilToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :paid_until, :date

    User.all.each do |user|
      paid_until_date = user.last_payment&.end_date
      if paid_until_date.present?
        user.update_columns paid_until: paid_until_date
      end
    end
  end

  def down
    remove_column :users, :paid_until, :date
  end
end
