class GooglePlaces

  API_KEY = ENV["GOOGLE_API_KEY"]

  # PRICING
  # https://developers.google.com/maps/billing/gmp-billing#nearby-search
  # degrees, minutes, seconds to decimal
  # https://www.fcc.gov/media/radio/dms-decimal
  # find lat lng bounding box here: https://boundingbox.klokantech.com/
  def self.get_google_restaurants(lat, lng, pagetoken=nil)
    # lat long for Beverly Estates Bryan, TX 77802
    #lat = "30.6362"
    #lng = "-96.3352"
    meter_radius = "1609" #1 mile
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?" +
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

=begin
response has next_page_token
data.deep_symbolize_keys!
data[:results].first
{:business_status=>"OPERATIONAL",
 :geometry=>
  {:location=>{:lat=>30.6227152, :lng=>-96.3414062},
   :viewport=>
    {:northeast=>{:lat=>30.62403042989272, :lng=>-96.34017512010728},
     :southwest=>{:lat=>30.62133077010727, :lng=>-96.34287477989272}}},
 :icon=>
  "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
 :name=>"IHOP",
 :opening_hours=>{:open_now=>true},
 :photos=>
  [{:height=>4032,
    :html_attributions=>
     ["<a href=\"https://maps.google.com/maps/contrib/115991101073668724509\">John S. Wagner</a>"],
    :photo_reference=>
     "ATtYBwIZjKG7Ou6wxaSevU4E-HEbdsKbB26zIBf-_BG9kknhODt4LpT1DgdjfYedupqq75iYupoalJciEwHDUzERqDqjsrrA9HqAdEtVECoILncgH31YbUVLLdgAHWKlVKgzAYctDSBIfC8zR7eKLGAlXi_KQ3eS6h6PNfQclS8WH5geDKsg",
 :place_id=>"ChIJdfyNs5WDRoYRhNRuk-DLX1E",
 :plus_code=>
  {:compound_code=>"JMF5+3C College Station, Texas",
   :global_code=>"8625JMF5+3C"},
 :price_level=>1,
 :rating=>3.8,
 :reference=>"ChIJdfyNs5WDRoYRhNRuk-DLX1E",
 :scope=>"GOOGLE",
 :types=>["restaurant", "food", "point_of_interest", "establishment"],
 :vicinity=>"103 College Ave, College Station"}
=end

  def self.get_restaurant_details(place_id)
    #place_id = "ChIJdfyNs5WDRoYRhNRuk-DLX1E"
    url = "https://maps.googleapis.com/maps/api/place/details/json?" +
          "place_id=#{place_id}&" +
          "key=#{API_KEY}"
    begin
      return HTTParty.get(url, {}).parsed_response
    rescue Exception => e
      puts e
      return nil
    end
  end

  def self.import_details_for_all_restaurants(place_ids=[], pagetoken=nil)
    data = self.get_google_restaurants(pagetoken)
    data.deep_symbolize_keys!
    data[:results].each do |rest|
      place_id = rest[:place_id]
      if place_id
        place_ids << place_id
        details = self.get_restaurant_details(place_id)
        Restaurant.import_restaurant_details_from_google(details)
      end
    end
    pagetoken = data[:next_page_token]
    if pagetoken
      puts "#######################################################"
      puts "#######################################################"
      puts "#######################################################"
      puts pagetoken
      puts "#######################################################"
      puts "#######################################################"
      self.import_details_for_all_restaurants(place_ids, pagetoken)
    else
      puts place_ids
    end
  end

  def self.get_restaurants_from_north_to_south(lat_max, lat_min, lng)
    # 20 miles = 105,600 feet / 1000 feet = 105.6 times API will be called
    # 269,852 / 105.6 = 2555.42 distance moved each time
    # 105.6 * 3 pages = 316.8
    # 316.8 * 105.6 = 33,454.08 times called in total / 1000
    # = 33.45 * $32 = $1070 when seperating by 1000 feet
    lat = lat_max
    distance_to_move = 2555.42
    until lat <= lat_min
      self.get_restaurants_for_lat_lng(lat, lng)
      if lat - distance_to_move < lat_min
        lat -= lat_min
      else
        lat -= distance_to_move
      end
    end
  end

  def self.get_restaurants_for_area(lat_max=nil, lat_min=nil,
                                    lng_max=nil, lng_min=nil)
    # lat/lng box
    # north west point 30.748374, -96.462306 (462306 - 192454 = 269,852 lng diff)
    # north east point 30.748374, -96.192454 (748374 - 532459 = 215,915 lat diff)
    # south east point 30.532459, -96.192454
    # south west point 30.532459, -96.462306
    lat_max = 30.748374
    lat_min = 30.532459
    lng_max = -96.192454
    lng_min = -96.462306
    distance_to_move = 2555.42
    # start at lat/lng max
    # 20 miles = 105,600 feet / 1000 feet = 105.6 times API will be called
    # 269,852 / 105.6 = 2555.42 distance moved each time
    # go down lat
    # keep removing 500 until get at bottom
    lng = lng_max
    until lng <= lng_min
      self.get_restaurants_from_north_to_south(lat_max, lat_min, lng)
      if lng - distance_to_move < lng_min
        lng -= lng_min
      else
        lng -= distance_to_move
      end
    end

  end

=begin
{"html_attributions"=>[],
 "result"=>
  {"address_components"=>
    [{"long_name"=>"103", "short_name"=>"103", "types"=>["street_number"]},
     {"long_name"=>"College Avenue",
      "short_name"=>"College Ave",
      "types"=>["route"]},
     {"long_name"=>"Northgate",
      "short_name"=>"Northgate",
      "types"=>["neighborhood", "political"]},
     {"long_name"=>"College Station",
      "short_name"=>"College Station",
      "types"=>["locality", "political"]},
     {"long_name"=>"Brazos County",
      "short_name"=>"Brazos County",
      "types"=>["administrative_area_level_2", "political"]},
     {"long_name"=>"Texas",
      "short_name"=>"TX",
      "types"=>["administrative_area_level_1", "political"]},
     {"long_name"=>"United States",
      "short_name"=>"US",
      "types"=>["country", "political"]},
     {"long_name"=>"77840", "short_name"=>"77840", "types"=>["postal_code"]}],
   "adr_address"=>
    "<span class=\"street-address\">103 College Ave</span>, <span class=\"locality\">College Station</span>, <span class=\"region\">TX</span> <span class=\"postal-code\">77840</span>, <span class=\"country-name\">USA</span>",
   "business_status"=>"OPERATIONAL",
   "formatted_address"=>"103 College Ave, College Station, TX 77840, USA",
   "formatted_phone_number"=>"(979) 846-7073",
   "geometry"=>
    {"location"=>{"lat"=>30.6227152, "lng"=>-96.3414062},
     "viewport"=>
      {"northeast"=>{"lat"=>30.6240295802915, "lng"=>-96.3401759697085},
       "southwest"=>{"lat"=>30.6213316197085, "lng"=>-96.3428739302915}}},
   "icon"=>
    "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
   "international_phone_number"=>"+1 979-846-7073",
   "name"=>"IHOP",
   "opening_hours"=>
    {"open_now"=>true,
     "periods"=>
      [{"close"=>{"day"=>1, "time"=>"2200"},
        "open"=>{"day"=>1, "time"=>"0600"}},
       {"close"=>{"day"=>2, "time"=>"2200"},
        "open"=>{"day"=>2, "time"=>"0600"}},
       {"close"=>{"day"=>3, "time"=>"2200"},
        "open"=>{"day"=>3, "time"=>"0600"}},
       {"close"=>{"day"=>0, "time"=>"2200"},
        "open"=>{"day"=>4, "time"=>"0600"}}],
     "weekday_text"=>
      ["Monday: 6:00 AM – 10:00 PM",
       "Tuesday: 6:00 AM – 10:00 PM",
       "Wednesday: 6:00 AM – 10:00 PM",
       "Thursday: 6:00 AM – 12:00 AM",
       "Friday: Open 24 hours",
       "Saturday: Open 24 hours",
       "Sunday: 12:00 AM – 10:00 PM"]},
   "photos"=>
    [{"height"=>3456,
      "html_attributions"=>
       ["<a href=\"https://maps.google.com/maps/contrib/112211163110323359379\">Muhammad Yasin</a>"],
      "photo_reference"=>
       "ATtYBwLsidZ9HMEUt5VMmsqrRwG-IZgbLVEmg72JH3JjK-WVQPmlCQjyhTVG-kf4DbNueKpAEUO7sYGZVop2X7K3eruq1mB5h6-9FRvwfKAsqAIfjoRy1nL3tbEODCb_XFNaHqVWITR9pbUFukz762m7VU6L4TYyXIhr0lay5GvI8ImcV8ff",
      "width"=>4608},
     {"height"=>280,
      "html_attributions"=>
       ["<a href=\"https://maps.google.com/maps/contrib/111320475762480081354\">IHOP</a>"],
      "photo_reference"=>
       "ATtYBwK_IhuaIQSpVVFlZNye8pfJ9G_Z_3qk27XS3CSA3c_2nf3qy6o_YoAP2d0eNHK2hbClzEse6i-3z6iXGey1lpXf20OsGbZeBPbumit5QZt6uWoSs0sWrFgBQ-PQoZJrwyuw8kyzNSXDO_zcEpoj2OaIDOOiu0wspS3UlYlgaGvHcF-V",
      "width"=>500},
   ],
   "place_id"=>"ChIJdfyNs5WDRoYRhNRuk-DLX1E",
   "plus_code"=>
    {"compound_code"=>"JMF5+3C College Station, TX, USA",
     "global_code"=>"8625JMF5+3C"},
   "price_level"=>1,
   "rating"=>3.8,
   "reference"=>"ChIJdfyNs5WDRoYRhNRuk-DLX1E",
   "reviews"=>
    [{"author_name"=>"Noelle",
      "author_url"=>
       "https://www.google.com/maps/contrib/107410484004714086701/reviews",
      "language"=>"en",
      "profile_photo_url"=>
       "https://lh3.googleusercontent.com/a/AATXAJyVpZg3dQS2G-JiK_3mB_tjgWSFMMoetVYBmd9m=s128-c0x00000000-cc-rp-mo",
      "rating"=>2,
      "relative_time_description"=>"3 weeks ago",
      "text"=>
       "The server Billy does not need to be working in the customer service industry. Strongly suspect this instance was race related. Will not be back as long as he continues to work there.\n" +
       "\n" +
       "2 stars only because the food was good.\n" +
       "\n" +
       "It's a shame to receive such poor service when I could see the other servers going the extra mile for their customers.",
      "time"=>1621534637},
     {"author_name"=>"Patricia Jacobs",
      "author_url"=>
       "https://www.google.com/maps/contrib/113144044690589825325/reviews",
      "language"=>"en",
      "profile_photo_url"=>
       "https://lh3.googleusercontent.com/a/AATXAJzbWGZ_0G5Npac7fzMHc5NjuQSJ3x01ZixJ0n5l-7M=s128-c0x00000000-cc-rp-mo-ba5",
      "rating"=>3,
      "relative_time_description"=>"9 months ago",
      "text"=>
       "Staff was wonderful. No gluten free product available even though it was on the menu.",
      "time"=>1599846189},
   ],
   "types"=>["restaurant", "food", "point_of_interest", "establishment"],
   "url"=>"https://maps.google.com/?cid=5863629405266302084",
   "user_ratings_total"=>1171,
   "utc_offset"=>-300,
   "vicinity"=>"103 College Avenue, College Station",
   "website"=>
    "https://restaurants.ihop.com/en-us/tx/college-station/breakfast-103-college-ave-1375?utm_source=Google&utm_medium=Maps&utm_campaign=Google+Places"},
 "status"=>"OK"}
=end


  def self.import_restaurant_details_from_google(data)
    data.deep_symbolize_keys!
    return unless data && data[:result]
    result = data[:result]
    return unless result && result[:place_id]
    rest = self.find_or_initialize_by(google_place_id: result[:place_id])
    # NAME
    rest.name = result[:name] if result[:name]
    rest.status = "not_contacted"
    # GOOGLE ICON
    rest.google_icon = result[:icon] if result[:icon]
    # BUSINESS STATUS
    if result[:business_status]
      rest.google_business_status = result[:business_status]
    end
    # PHONE NUMBER
    if result[:international_phone_number]
      rest.primary_phone_number = result[:international_phone_number]
    end
    # WEBSITE
    rest.website_url = result[:website] if result[:website]
    # GOOGLE MAP URL
    rest.google_map_url = result[:url] if result[:url]
    # RATINGS
    rest.google_rating_avg = result[:rating] if result[:rating]
    if result[:user_ratings_total]
      rest.google_ratings_total = result[:user_ratings_total]
    end
    # ALL DETAILS IN JSON
    rest.google_all_details_json = result.to_json
    rest.save!

    address = rest.address
    address = Address.new(restaurant_id: rest.id) if !address
    # GEOCODED ADDRESS
    if result[:formatted_address]
      address.geocoded_address = result[:formatted_address]
    end
    # LATITUDE
    if result[:geometry][:location][:lat]
      address.latitude = result[:geometry][:location][:lat]
    end
    # LONGITUDE
    if result[:geometry][:location][:lng]
      address.longitude = result[:geometry][:location][:lng]
    end
    address.save!
    return
  end

end
