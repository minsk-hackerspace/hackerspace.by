#encoding: utf-8
class AddProjectStatus < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :project_status, :string, default: 'активный'
  end
end
