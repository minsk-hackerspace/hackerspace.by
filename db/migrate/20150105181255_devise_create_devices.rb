class DeviseCreateDevices < ActiveRecord::Migration[4.2]
  def change
    create_table(:devices) do |t|
      ## Database authenticatable
      t.string :name,               null: false
      t.string :encrypted_password, null: false

      t.timestamps
    end
  end
end
