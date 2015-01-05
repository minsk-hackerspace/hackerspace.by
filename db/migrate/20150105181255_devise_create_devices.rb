class DeviseCreateDevices < ActiveRecord::Migration
  def change
    create_table(:devices) do |t|
      ## Database authenticatable
      t.string :name,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.timestamps
    end
  end
end
