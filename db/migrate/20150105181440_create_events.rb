class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :event_type, null_allowed: false
      t.string :value, null_allowed: false
      t.belongs_to :device

      t.timestamps
    end
  end
end
