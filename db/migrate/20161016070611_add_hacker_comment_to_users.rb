class AddHackerCommentToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :hacker_comment, :string
    add_column :users, :badge_comment, :string
  end
end
