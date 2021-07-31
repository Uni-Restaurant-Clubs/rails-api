class University < ApplicationRecord
  has_many :writers
  has_many :photographers
  has_many :restaurants
  has_many :reviews

  validates_presence_of :name
end
