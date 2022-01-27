ActiveAdmin.register AdminUserRole do
  actions :all, :except => [:destroy]

  belongs_to :admin_user
  belongs_to :role
  navigation_menu :admin_user
  navigation_menu :role
end
