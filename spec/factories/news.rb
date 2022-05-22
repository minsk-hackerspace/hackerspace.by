# == Schema Information
#
# Table name: news
#
#  id                         :integer          not null, primary key
#  title                      :string
#  short_desc                 :text
#  description                :text
#  photo_file_name            :string
#  photo_content_type         :string
#  photo_file_size            :integer
#  photo_updated_at           :datetime
#  user_id                    :integer
#  public                     :boolean
#  markup_type                :string
#  created_at                 :datetime
#  updated_at                 :datetime
#  show_on_homepage           :boolean
#  show_on_homepage_till_date :datetime
#
FactoryBot.define do
  factory :news do
    title { 'Title' }
    user
    markup_type { News::SUPPORTED_MARKUPS.first }
    show_on_homepage_till_date { Time.now + 1.day }
  end
end
