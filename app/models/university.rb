class University < ApplicationRecord
  has_many :writers, class_name: 'ContentCreator'
  has_many :photographers, class_name: 'ContentCreator'
  has_many :restaurants
  has_many :reviews

  enum school_type: { "university" => 0, "college" => 1}

  validates_presence_of :name, :school_type
end
