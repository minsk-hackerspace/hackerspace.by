# == Schema Information
#
# Table name: projects
#
#  id                 :integer          not null, primary key
#  name               :string
#  short_desc         :text
#  full_desc          :text
#  image              :string
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  user_id            :integer
#  markup_type        :string           default("html")
#  public             :boolean          default(FALSE)
#  project_status     :string           default("активный")
#
# Indexes
#
#  index_projects_on_user_id  (user_id)
#

require 'rails_helper'

describe Project do
  pending "add some examples to (or delete) #{__FILE__}"
end
