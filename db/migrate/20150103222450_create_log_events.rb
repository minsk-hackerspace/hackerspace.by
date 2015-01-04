class CreateLogEvents < ActiveRecord::Migration
  def change
    create_table :log_events do |t|
      t.string :event_type, null_allowed: false
      t.string :value, null_allowed: false
      t.datetime :timestamp

      t.timestamps
    end
  end
end
