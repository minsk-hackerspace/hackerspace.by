class AddMarkupTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :markup_type, :string, :default => 'html'
  end
end
