class AddSuspendedChangedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :suspended_changed_at, :datetime, null: false,
                                              default: Time.now - 10.year
  end
end
