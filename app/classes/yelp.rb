class Yelp
  # https://www.yelp.com/fusion
  # https://github.com/Yelp/yelp-fusion/blob/master/fusion/ruby/sample.rb
  # https://www.yelp.com/developers/documentation/v3/get_started

  def self.get_restaurants_subset(offset=0)
    # lat long for Beverly Estates Bryan, TX 77802
    lat = "30.6362"
    lng = "-96.3352"
    meter_radius = "40000" #1 mile
    url = "https://api.yelp.com/v3/businesses/search?" +
    "term=restaurants&" +
    "latitude=#{lat}&" +
    "longitude=#{lng}&" +
    "radius=#{meter_radius}&" +
    "limit=50&" +
    "offset=#{offset}&"

    options = {
      headers: {
        Authorization: "Bearer #{ENV["YELP_API_KEY"]}"
      }
    }

    begin
      return HTTParty.get(url, options).parsed_response
    rescue Exception => e
      puts e
    end
  end

  def self.get_all_restaurants_ids

    restaurants_left = true
    restaurant_ids = []
    while restaurants_left
      offset = restaurant_ids.count
      data = self.get_restaurants_subset(offset)
      data.deep_symbolize_keys!
      if data.first.second.any?
        data.first.second.each do |restaurant|
          restaurant_ids << restaurant[:id]
        end
      else
        restaurants_left = false
      end
    end
    return restaurant_ids
  end

end
