class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_type, null_allowed: false
      t.string :value, null_allowed: false
      t.belongs_to :device, index: true

      t.timestamps
    end
  end
end
