class AdminUserRole < ApplicationRecord
  belongs_to :admin_user
  belongs_to :role

  validates_presence_of :admin_user_id, :role_id
  validates_uniqueness_of :admin_user_id, scope: :role_id,
                          message: "already has this role"
end
