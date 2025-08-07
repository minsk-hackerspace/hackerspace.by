# frozen_string_literal: true

# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  key         :string           not null
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#
# Indexes
#
#  index_settings_on_key  (key)
#

class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  def self.[](key)
    return 'test' if Rails.env.test?

    s = Setting.where(key: key).first
    return nil if s.nil?

    s.value
  end

  def self.[]=(key, value)
    s = Setting.where(key: key).first
    s = Setting.new(key: key) if s.nil?
    s.value = value
    s.save
  end
end
