class LogEvent < ActiveRecord::Base
  validates :timestamp, presence: true
  validate  :timestamp_is_in_the_past
  validates :event_type, inclusion: { in: %w(light) }
  validates :value, presence: true


  private

  def timestamp_is_in_the_past
    if timestamp.present? and timestamp > Time.now
      errors.add(:timestamp, "should be in the past")
    end
  end
end
