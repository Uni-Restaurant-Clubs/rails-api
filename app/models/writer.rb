class Writer < ApplicationRecord
  has_many :reviews
  has_one :image
  belongs_to :university

  validates_presence_of :first_name, :last_name, :email, :phone, :university_id

  accepts_nested_attributes_for :image, :allow_destroy => true

  def name
    first_name + " " + last_name
  end
end
