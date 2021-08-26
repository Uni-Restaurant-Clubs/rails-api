class ContentCreator < ApplicationRecord
  has_many :reviews
  has_one :image

  belongs_to :university, optional: true

  has_one_attached :signed_nda
  has_one_attached :signed_agreement

  validates_presence_of :first_name, :last_name, :email, :phone, :signed_nda,
    :signed_agreement, :public_unique_username, :creator_type
  validates_uniqueness_of :public_unique_username

  enum creator_type: { writer: 0, photographer: 1 }

  accepts_nested_attributes_for :image, :allow_destroy => true

  def name
    first_name + " " + last_name
  end

end
