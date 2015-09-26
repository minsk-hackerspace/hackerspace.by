class News < ActiveRecord::Base
  SUPPORTED_MARKUPS = Project::SUPPORTED_MARKUPS

  belongs_to :user

  has_attached_file :photo,
                    styles: {
                        original: '600x600>',
                        medium: '300x300>',
                        thumb: '200x200>'
                    },
                    default_url: 'default.png'

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates_attachment :photo, size: { in: 0..3.megabytes }
  validates :markup_type, inclusion: SUPPORTED_MARKUPS
  validates :show_on_homepage_till_date, presence: true, if: :show_on_homepage

  scope :published, -> { where public: true }
  scope :homepage, -> { where show_on_homepage: true }
end
