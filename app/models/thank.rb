# == Schema Information
#
# Table name: thanks
#
#  id                 :integer          not null, primary key
#  name               :string
#  short_desc         :text
#  full_desc          :text
#  image              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  user_id            :integer
#  markup_type        :string           default("html")
#  public             :boolean          default(FALSE)
#
# Indexes
#
#  index_thanks_on_user_id  (user_id)
#

class Thank < ApplicationRecord

  SUPPORTED_MARKUPS = %w(html markdown)

  belongs_to :user

  has_attached_file :photo,
                    styles: {
                        original: '600x600>',
                        medium: '400x400#',
                        thumb: '200x200>'
                    },
                    default_url: 'default.png'

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates_attachment :photo, presence: true, size: { in: 0..3.megabytes }


  validates :name, uniqueness: true
  validates :name, :short_desc, presence: true
  validates :markup_type, inclusion: SUPPORTED_MARKUPS
  scope :published, -> { where public: true }

  def name_with_id
    "#{self.id}. #{self.name}"
  end
end
