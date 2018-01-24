# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  key         :string           not null
#  value       :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_settings_on_key  (key)
#

require 'rails_helper'

RSpec.describe Setting, type: :model do
  it { should validate_presence_of(:key) }
end
