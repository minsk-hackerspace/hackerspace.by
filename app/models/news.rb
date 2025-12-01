# frozen_string_literal: true

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

class News < ApplicationRecord
  SUPPORTED_MARKUPS = Project::SUPPORTED_MARKUPS

  belongs_to :user

  has_one_attached :photo do |attachable|
    attachable.variant :original, resize_to_limit: [600, 600], preprocessed: true
    attachable.variant :medium, resize_to_limit: [500, 500], preprocessed: true
    attachable.variant :thumb, resize_to_limit: [200, 200], preprocessed: true
  end
  validates :photo, content_type: ['image/png', 'image/jpeg'],
            size: { less_than: 3.megabytes }, if: -> { photo.attached? }

  validates :markup_type, inclusion: SUPPORTED_MARKUPS
  validates :show_on_homepage_till_date, presence: true, if: :show_on_homepage

  scope :published, -> { where public: true }
  scope :homepage, -> { where show_on_homepage: true }
end
