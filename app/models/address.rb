class Address < ApplicationRecord

  belongs_to :restaurant

  validates_presence_of [:street_number, :street_name, :street_type, :city,
                         :state, :country, :zipcode]

  geocoded_by :full_address
  reverse_geocoded_by :latitude, :longitude, :address => :geocoded_address
  after_validation :geocode, reverse_geocode,
                   :if => lambda{ |obj| obj.full_address_changed? }

  enum city: { united_states: 0 }
  enum country: { united_states: 0 }
  def full_address
    [apt_suite_number, street_number, street_name, street_type, city, state,
     country, zipcode].compact.join(', ')
  end
end
