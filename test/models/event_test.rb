# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  event_type :string
#  value      :string
#  device_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  repeated   :boolean          default(FALSE)
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
