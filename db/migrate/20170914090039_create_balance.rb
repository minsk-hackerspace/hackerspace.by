class CreateBalance < ActiveRecord::Migration[5.0]
  def change
    create_table :balances do |t|
      t.float :state, null: false
      t.timestamps index: true
    end
  end
end
