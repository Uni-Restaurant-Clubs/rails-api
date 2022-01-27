ActiveAdmin.register AdminUserRole do
  belongs_to :admin_user
  belongs_to :role
end
