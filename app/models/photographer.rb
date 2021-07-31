class Photographer < ApplicationRecord
  has_many :reviews
  has_many :images
  belongs_to :university

  validates_presence_of :first_name, :last_name, :email, :phone, :university_id

  def name
    first_name + " " + last_name
  end
end
