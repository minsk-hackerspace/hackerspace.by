# frozen_string_literal: true

# == Schema Information
#
# Table name: users_roles
#
#  user_id :integer          not null
#  role_id :integer          not null
#
# Indexes
#
#  index_users_roles_on_role_id              (role_id)
#  index_users_roles_on_user_id              (user_id)
#  index_users_roles_on_user_id_and_role_id  (user_id,role_id) UNIQUE
#

class UsersRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
end
