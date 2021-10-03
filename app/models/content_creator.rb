class ContentCreator < ApplicationRecord
  has_many :reviews, ->(creator) {
    unscope(:where).where(photographer_id: creator.id).or(where(writer_id: creator.id))
  }
  has_one :image, dependent: :destroy
  has_many :review_happened_confirmation, dependent: :destroy
  belongs_to :location_code

  belongs_to :university, optional: true

  has_one_attached :signed_nda
  has_one_attached :signed_agreement

  validates_presence_of :first_name, :last_name, :email, :phone, :signed_nda,
    :signed_agreement, :public_unique_username, :creator_type, :location_code_id
  validates_uniqueness_of :public_unique_username
  validates :bio, length: { maximum: 1000 }

  enum creator_type: { writer: 0, photographer: 1 }

  accepts_nested_attributes_for :image, :allow_destroy => true

  scope :writers, lambda { where(creator_type: "writer") }
  scope :photographers, lambda { where(creator_type: "photographer") }

  def name
    first_name + " " + last_name
  end

end
