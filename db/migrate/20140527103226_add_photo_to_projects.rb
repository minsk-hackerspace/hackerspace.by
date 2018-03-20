class AddPhotoToProjects < ActiveRecord::Migration[4.2]
  def self.up
    add_attachment :projects, :photo
  end

  def self.down
    remove_attachment :projects, :photo
  end
end

