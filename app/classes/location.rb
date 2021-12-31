class Location < ApplicationRecord

  def self.close_enough(address_to_compare, other_lat_lng)
    address_one = [address_to_compare[:latitude],
                   address_to_compare[:longitude]]
    address_two = [other_lat_lng[:currentLatitude],
                   other_lat_lng[:currentLongitude]]
    distance = Geocoder::Calculations.distance_between(address_one, address_two)
    # http://obeattie.github.io/gmaps-radius/?lat=45.508644&lng=-73.572213&z=18&u=mi&r=0.0621371
    return distance <= 0.0621371 # 100 meters
  end

end
