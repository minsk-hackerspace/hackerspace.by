class AddUserToProjects < ActiveRecord::Migration
  def change
    add_belongs_to :projects, :user, index: true
  end
end
