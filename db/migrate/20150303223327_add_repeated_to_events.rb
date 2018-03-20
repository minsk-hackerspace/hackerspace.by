class AddRepeatedToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :repeated, :boolean, default: false
  end
end
