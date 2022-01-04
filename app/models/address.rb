class Address < ApplicationRecord

  belongs_to :restaurant

  geocoded_by :full_address, lookup: :google
  reverse_geocoded_by :latitude, :longitude, :address => :geocoded_address

  #before_save :geocode, :reverse_geocode, if: :address_changed

  def full_address
    address = address_1
    address += " #{address_2}" if address_2.present?
    address += " #{address_3}" if address_3.present?
    address += ", #{city}, #{state}, #{zipcode}"
    address
  end

  def city_state
    "#{city}, #{state}"
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
