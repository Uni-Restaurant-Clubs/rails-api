class TravelAdvisor

  # https://rapidapi.com/apidojo/api/travel-advisor/
  def self.get_google_restaurants(lat, lng, pagetoken=nil)
    # lat long for Beverly Estates Bryan, TX 77802
    lat = "30.6362"
    lng = "-96.3352"
    meter_radius = "1609" #1 mile
    url = "https://travel-advisor.p.rapidapi.com/restaurants/list-by-latlng?" +
    "location=#{lat},#{lng}&" +
    "radius=#{meter_radius}&" +
    "type=restaurant&" +
    "fields=place_id&" +
    "key=#{API_KEY}"
    url += "&pagetoken=#{pagetoken}" if pagetoken

    begin
      return HTTParty.get(url, {}).parsed_response
    rescue Exception => e
      puts e
    end
  end



end
