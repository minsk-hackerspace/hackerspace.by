class AddUserToProjects < ActiveRecord::Migration[4.2]
  def change
    add_belongs_to :projects, :user, index: true
  end
end
