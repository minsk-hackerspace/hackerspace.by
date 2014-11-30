#encoding: utf-8
class AddProjectStatus < ActiveRecord::Migration
  def change
    add_column :projects, :project_status, :string, default: 'активный'
  end
end
