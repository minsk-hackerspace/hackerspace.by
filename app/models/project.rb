require 'paperclip'

class Project < ActiveRecord::Base

  SUPPORTED_MARKUPS = %w(html markdown)

  has_attached_file :photo, styles: { original: '600x600>', medium: '300x300>', thumb: '200x200>' }, default_url: 'default.png'
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates_attachment :photo, presence: true, size: { in: 0..3.megabytes }

  validates :name, presence: true
  validates :short_desc, presence: true
  validates :markup_type, :inclusion => SUPPORTED_MARKUPS

  belongs_to :user, dependent: :delete

end
