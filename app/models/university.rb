class University < ApplicationRecord
  has_many :writers
  has_many :photographers
  has_many :restaurants
  has_many :reviews

  enum school_type: { "university" => 0, "college" => 1}

  validates_presence_of :name
end
