class Role < ApplicationRecord
  has_many :admin_user_roles
  has_many :roles, through: :admin_user_roles

  validates_presence_of :name, :description
  accepts_nested_attributes_for :admin_user_roles, :allow_destroy => true
end
