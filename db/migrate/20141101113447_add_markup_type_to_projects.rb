class AddMarkupTypeToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :markup_type, :string, :default => 'html'
  end
end
