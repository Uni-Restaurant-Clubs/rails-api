class GooglePlaces

  API_KEY = ENV["GOOGLE_API_KEY"]

  def self.get_google_restaurants(pagetoken=nil)
    # lat long for Beverly Estates Bryan, TX 77802
    lat = "30.6362"
    lng = "-96.3352"
    meter_radius = "16093" #10 miles
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

  def self.import_details_for_all_restaurants(pagetoken=nil)
    data = self.get_google_restaurants(pagetoken)
    data.deep_symbolize_keys!
    data[:results].each do |rest|
      place_id = rest[:place_id]
      if place_id
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
    end
    self.import_details_for_all_restaurants(pagetoken) if pagetoken
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
     {"height"=>1597,
      "html_attributions"=>
       ["<a href=\"https://maps.google.com/maps/contrib/111320475762480081354\">IHOP</a>"],
      "photo_reference"=>
       "ATtYBwIMoQWQDovstuukekCjwFrgxQRvcxjjh2hDtiuySCMr8xTm9J7Yi2Gf1yZzwZFEIHq4ACTOeiXmca-81JydAXv7sqagNqBsS3yglJvU-mUJiTUHAtcXjWbV4XAnz-x1NJnU67txeSYQro2N_-NQUrsWKrbLiwjbbukkQPrvgFa_NIDr",
      "width"=>2400},
     {"height"=>1600,
      "html_attributions"=>
       ["<a href=\"https://maps.google.com/maps/contrib/111320475762480081354\">IHOP</a>"],
      "photo_reference"=>
       "ATtYBwJNamhinjxxEwIz7Dg5AonYvObBghJrnTHAeIlDcMhslgcmw5kZyzcsfkqgc1b2IldeO2rQrO3AhyiMcsVO7HhcgkHH7bLyACWAGUTgkatekp2TeGrwecAlJRoDA-MJ0kjJwtiJov5c4M0c7261Ht6EMHl6aZq_P3jYOy6qbV_Btax8",
      "width"=>2400},
     {"height"=>1600,
      "html_attributions"=>
       ["<a href=\"https://maps.google.com/maps/contrib/111320475762480081354\">IHOP</a>"],
      "photo_reference"=>
       "ATtYBwK7lPVc7Nc710e1AhlivWKVFol1NGfD8G7RMjnWv-rHTZrcr93BV3kXX0ag8rDjr1FZSZhy8_YONx8-cdBaNHdt0N-GC7C76p-Vck8lyelF8ZnO9pZZMx01_m_NXtuHRfdNQeaMhb_1iS4w1inoY4BzyKYIr9STuaJVyew_hlMJs_f8",
      "width"=>2400},
     {"height"=>4032,
      "html_attributions"=>
       ["<a href=\"https://maps.google.com/maps/contrib/104548543359481593697\">SIRENIA CEBRERO</a>"],
      "photo_reference"=>
       "ATtYBwLBY8pcY4-oDWYJFJJSpBwFVWJx6SpteJb5tq5NGxXAcIHfOJuLFVXCfKGDUweEr9BaMzvp701IcbdiKSddmrE9pt5AkmrxE_gKAJVcF_5nMqbVguNohigX6XlkB4fr3zMU7uUUxRQ6dLipUSEGwr5A6u5a2AqLjYtnKMq2aiBiBTIW",
      "width"=>3024},
     {"height"=>1600,
      "html_attributions"=>
       ["<a href=\"https://maps.google.com/maps/contrib/111320475762480081354\">IHOP</a>"],
      "photo_reference"=>
       "ATtYBwLdbm5roe6zR4fPCPH3E5m2fvecEZ_2wD3dKQDaVYLailXxl-mHo9RyjMyFrW03TJlbG4d53tVGQzDC7W9edP8aUlw-4qYo7PRQi5KHbjIikl4v5DAzC2uV82q1BCjMokCD1Ir7g79NljDZeDO670MuPsVf9Ps9XDEs8hylY8BYNEFL",
      "width"=>2400},
     {"height"=>4074,
      "html_attributions"=>
       ["<a href=\"https://maps.google.com/maps/contrib/109239011364864713570\">Nusrat Trisha</a>"],
      "photo_reference"=>
       "ATtYBwIVPRh59hHEJ_yVVEPe1cSrEyR845w97F5Xqw7ZWt-mI4YyU-sZfIhzirNwUOAxwp-Ba21eG2SOhR-ZKVZgIKUjiYqDl4TR_NNKrGjfjZVYOFvY1SWkxctsLHOOkb7JadYUdUq79KeUZQDvNnApiVm6Z1JprOFvCVZYcdxkv7vPhtQl",
      "width"=>3056},
     {"height"=>3056,
      "html_attributions"=>
       ["<a href=\"https://maps.google.com/maps/contrib/109239011364864713570\">Nusrat Trisha</a>"],
      "photo_reference"=>
       "ATtYBwKtq4WyIiadPkN9RVvumlCG6GhhzOyjMsKYKskb94ox4eYmUJapW2WvLa88KyhjzlykPn6NY1-JQt_Y30gnIvCNeGhdLl7gF9E5dvzS875HDIvypN2d766qNQNNbfb8hZKDx9_ljRNZevQnkw7-rQAmihl4e3BReVNhcrCWb_JhLZTn",
      "width"=>4074},
     {"height"=>4032,
      "html_attributions"=>
       ["<a href=\"https://maps.google.com/maps/contrib/115263790490418167061\">Anjushree Iyer</a>"],
      "photo_reference"=>
       "ATtYBwJVPru5erm3fosVfyFBqABAWLFb7ENi2KvO1TH_90k6_XxO3fek8b6Pb1UyC9KavzVlMM8U7l8C3KNTbD2cZuZGlfoUBMaPK5RmoIsTsAih3KRm0yMExIjCEFRQacD2AViSDnr0FdUSfPmEuRMdhc2MwHNoU-f_5z-DIdmmtEV1U_Oq",
      "width"=>3024}],
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
     {"author_name"=>"Lucas Tjom",
      "author_url"=>
       "https://www.google.com/maps/contrib/111839444353873440854/reviews",
      "language"=>"en",
      "profile_photo_url"=>
       "https://lh3.googleusercontent.com/a/AATXAJy2UK23Z29tPVVv3rb-PGZLhg8vW-LN9hV13Mb5=s128-c0x00000000-cc-rp-mo",
      "rating"=>2,
      "relative_time_description"=>"a month ago",
      "text"=>
       "Good food, but told us it would be 25 minutes to get a table. That’s fine, but It ended up taking 40+ minutes to get the table. Should not have waited and just gotten better food.\n" +
       "Also took like 20 minutes to get our check after we were done eating.",
      "time"=>1620460230},
     {"author_name"=>"Alvaro Jaramillo",
      "author_url"=>
       "https://www.google.com/maps/contrib/117360225365500843039/reviews",
      "language"=>"en",
      "profile_photo_url"=>
       "https://lh3.googleusercontent.com/a-/AOh14Gh9hYhwqTlvJ2afkHfIR19131CqC8E7olJYZ2mZOA=s128-c0x00000000-cc-rp-mo-ba4",
      "rating"=>5,
      "relative_time_description"=>"2 months ago",
      "text"=>
       "First time at this location and really enjoyed it. Special shout out to our server, Jordan, he was really kind and accommodating. The food was great, the hashbrowns and pancakes were really good!! The bacon burger also had nice flavors to it.",
      "time"=>1618096118},
     {"author_name"=>"Jenn Satterwhite",
      "author_url"=>
       "https://www.google.com/maps/contrib/109696724125032730853/reviews",
      "language"=>"en",
      "profile_photo_url"=>
       "https://lh3.googleusercontent.com/a-/AOh14Gjnl3FjkWRn7-cfpUCVSaieqFoPMxfqN_I2CrQB3mQ=s128-c0x00000000-cc-rp-mo-ba4",
      "rating"=>4,
      "relative_time_description"=>"a month ago",
      "text"=>
       "Very friendly staff! Prompt service. Good food. Great place to pop in for a casual IHOP meal. It’s smaller than most IHOPs but that adds to the uniqueness.",
      "time"=>1620765635}],
   "types"=>["restaurant", "food", "point_of_interest", "establishment"],
   "url"=>"https://maps.google.com/?cid=5863629405266302084",
   "user_ratings_total"=>1171,
   "utc_offset"=>-300,
   "vicinity"=>"103 College Avenue, College Station",
   "website"=>
    "https://restaurants.ihop.com/en-us/tx/college-station/breakfast-103-college-ave-1375?utm_source=Google&utm_medium=Maps&utm_campaign=Google+Places"},
 "status"=>"OK"}
=end


end
