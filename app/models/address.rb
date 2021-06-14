class Address < ApplicationRecord

  belongs_to :restaurant

  validates_presence_of [:street_number, :street_name, :city,
                         :state, :country, :zipcode]

  geocoded_by :full_address, lookup: :google
  reverse_geocoded_by :latitude, :longitude, :address => :geocoded_address

  before_save :geocode, :reverse_geocode, if: :address_changed

  enum city: { "College Station" => 0 }
  enum state: { "Texas" => 0 }
  enum country: { "United States" => 0 }

  def full_address
    "#{street_number} #{street_name}, #{city}, #{state}, #{country}, #{zipcode}"
  end

  def address_changed
    street_number_changed? ||
    street_name_changed? ||
    city_changed? ||
    state_changed? ||
    country_changed? ||
    zipcode_changed?
  end
end
