class ContentCreator < ApplicationRecord
  has_many :reviews, ->(creator) {
    unscope(:where).where(photographer_id: creator.id).or(where(writer_id: creator.id))
  }
  has_one :image, dependent: :destroy
  has_many :review_happened_confirmation, dependent: :destroy
  belongs_to :location_code, optional: true

  belongs_to :university, optional: true

  has_one_attached :signed_nda
  has_one_attached :signed_agreement
  has_one_attached :resume
  has_one_attached :writing_example
  has_one_attached :intro_video

  validates_presence_of :first_name, :last_name, :email, :public_unique_username,
                        :location_code_id
  validates_uniqueness_of :public_unique_username, :allow_blank => true
  validates :bio, length: { maximum: 1000 }

  enum creator_type: { writer: 0, photographer: 1 }
  enum status: { applied: 0, accepted: 1, denied: 2, active: 3,
                 archived: 4, suspended: 5, inactive: 6 }

  accepts_nested_attributes_for :image, :allow_destroy => true

  scope :writers, lambda { where(is_writer: true) }
  scope :photographers, lambda { where(is_photographer: true) }
  scope :videographers, lambda { where(is_videographer: true) }

  scope :within_last_day, -> do
    where("created_at > ?", DateTime.now - 24.hours)
  end
  scope :within_last_7_days, -> do
    where("created_at > ?", DateTime.now - 7.days)
  end

  def self.create_public_unique_username(data)
    name = data[:first_name]&.downcase + "_" + data[:last_name]&.downcase
    number = ""
    loop do
      new_name = name + number.to_s
      break new_name unless self.exists?(public_unique_username: new_name)
      number = 0 if number == ""
      number += 1
    end
  end

  def name
    first_name + " " + last_name
  end

end
