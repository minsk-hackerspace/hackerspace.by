# == Schema Information
#
# Table name: devices
#
#  id                 :integer          not null, primary key
#  name               :string           not null
#  encrypted_password :string           not null
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
