class AddPhotoToProjects < ActiveRecord::Migration
  def self.up
    add_attachment :projects, :photo
  end

  def self.down
    remove_attachment :projects, :photo
  end
end

