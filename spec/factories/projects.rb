# == Schema Information
#
# Table name: projects
#
#  id                 :integer          not null, primary key
#  name               :string
#  short_desc         :text
#  full_desc          :text
#  image              :string
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  user_id            :integer
#  markup_type        :string           default("html")
#  public             :boolean          default(FALSE)
#  project_status     :string           default("активный")
#
# Indexes
#
#  index_projects_on_user_id  (user_id)
#
FactoryBot.define do
  factory :project do
    name { 'Title' }
    short_desc { 'Short description' }
    user

    photo { File.new(Rails.root.join('public', 'images', 'default.png')) }
    # after(:build) do |post|
    #   post.image.attach(
    #     io: File.open(Rails.root.join('test', 'fixture_files', 'test.jpg')),
    #     filename: 'test.jpg',
    #     content_type: 'image/jpeg'
    #   )
    # end
  end
end
