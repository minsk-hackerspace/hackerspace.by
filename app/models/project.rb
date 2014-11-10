# == Schema Information
#
# Table name: projects
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  short_desc         :text
#  full_desc          :text
#  image              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  user_id            :integer
#  markup_type        :string(255)      default("html")
#  public             :boolean          default(FALSE)
#

require 'paperclip'

class Project < ActiveRecord::Base

  SUPPORTED_MARKUPS = %w(html markdown)
  belongs_to :user, dependent: :delete

  has_attached_file :photo, styles: { original: '600x600>', medium: '300x300>', thumb: '200x200>' }, default_url: 'default.png'
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates_attachment :photo, presence: true, size: { in: 0..3.megabytes }

  validates :name, :short_desc, presence: true
  validates :markup_type, inclusion: SUPPORTED_MARKUPS

end
