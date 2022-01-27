class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :validatable

  has_many :admin_user_roles
  has_many :roles, through: :admin_user_roles
end
