class AddRepeatedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :repeated, :boolean, default: false
  end
end
