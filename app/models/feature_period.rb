class FeaturePeriod < ApplicationRecord
  has_many :check_ins, dependent: :destroy
  belongs_to :restaurant
end
