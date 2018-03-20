class AddPublicAttributeToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :public, :boolean, default: false
  end
end
