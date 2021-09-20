class Yelp
  # https://www.yelp.com/fusion
  # https://github.com/Yelp/yelp-fusion/blob/master/fusion/ruby/sample.rb
  # https://www.yelp.com/developers/documentation/v3/get_started

  def self.get_restaurants_subset(offset=0)
    # lat long for Brooklyn
    lat = "40.665475"
    lng = "-73.945006"
    meter_radius = "40000" #25 miles
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

  def self.import_restaurant_details(result)
    return unless result && result[:id]
    rest = Restaurant.find_or_initialize_by(yelp_id: result[:id])

    # YELP RATING
    rest.yelp_rating = result[:rating] if result[:rating]
    # YELP REVIEW COUNT
    rest.yelp_review_count = result[:review_count] if result[:review_count]
    # YELP PRIMARY PHONE NUMBER
    rest.primary_phone_number = result[:display_phone] if result[:display_phone]
    # NAME
    rest.name = result[:name] if result[:name]
    # YELP ALIAS
    rest.yelp_alias = result[:alias] if result[:alias]
    rest.status = "not contacted"
    # IMAGE_URL
    rest.image_url = result[:image_url] if result[:image_url]
    # PHONE NUMBER
    if result[:phone]
      rest.primary_phone_number = result[:phone]
    end
    # YELP URL
    rest.yelp_url = result[:url] if result[:url]
    rest.save!
    rest.add_categories(result[:categories])

    address = Address.find_or_initialize_by(restaurant_id: rest.id)
    lat_lng = result[:coordinates]
    if lat_lng
      # LATITUDE
      if lat_lng[:latitude]
        address.latitude = lat_lng[:latitude]
      end
      # LONGITUDE
      if lat_lng[:longitude]
        address.longitude = lat_lng[:longitude]
      end
    end

    location = result[:location]
    if location
      address.address_1 = location[:address1] if location[:address1]
      address.address_2 = location[:address2] if location[:address2]
      address.address_3 = location[:address3] if location[:address3]
      address.city = location[:city] if location[:city]
      address.state = location[:state] if location[:state]
      address.zipcode = location[:zip_code] if location[:zip_code]
      address.country = location[:country] if location[:country]
    end
    address.save!
  end

  # returns 498 vs only 293 for trip advisor
  def self.import_all_restaurants

    restaurants_left = true
    restaurant_ids = []
    restaurant_count = 0
    while restaurants_left
      data = self.get_restaurants_subset(restaurant_count)
      if data["error"]
        Airbrake.notify("restaurant importing error", {
          error: data["error"]
        })
        break
      end
      data.deep_symbolize_keys!
      if data[:businesses]&.any?
        data[:businesses].each do |restaurant|
          self.import_restaurant_details(restaurant)
          restaurant_count += 1
          puts restaurant_count
        end
      else
        restaurants_left = false
      end
    end
  end

=begin
results from search
{:id=>"rOfX5ve4f1PbShG-H6d5Fw",
 :alias=>"mess-college-station",
 :name=>"MESS",
 :image_url=>"https://s3-media3.fl.yelpcdn.com/bphoto/1hq0qCzH0jOmB3bk-84Qxw/o.jpg",
 :is_closed=>false,
 :url=>"https://www.yelp.com/biz/mess-college-station?adjust_creative=OGeha_o6Pn_MQscqLAAsMQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=OGeha_o6Pn_MQscqLAAsMQ",
 :review_count=>153,
 :categories=>[{:alias=>"tradamerican", :title=>"American (Traditional)"}, {:alias=>"breakfast_brunch", :title=>"Breakfast & Brunch"}, {:alias=>"comfortfood", :title=>"Comfort Food"}],
 :rating=>4.5,
 :coordinates=>{:latitude=>30.62631622008178, :longitude=>-96.33802467389921},
 :transactions=>["pickup", "delivery"],
 :price=>"$",
 :location=>
  {:address1=>"170 Century Square Dr",
   :address2=>"Ste 10",
   :address3=>nil,
   :city=>"College Station",
   :zip_code=>"77840",
   :country=>"US",
   :state=>"TX",
   :display_address=>["170 Century Square Dr", "Ste 10", "College Station, TX 77840"]},
 :phone=>"+19797045200",
 :display_phone=>"(979) 704-5200",
 :distance=>1131.7674800633347}

 {:id=>"iAr02yireKowmlRuxsbO_w",
 :alias=>"another-broken-egg-cafe-college-station",
 :name=>"Another Broken Egg Cafe",
 :image_url=>"https://s3-media2.fl.yelpcdn.com/bphoto/jm5tAn1M8E-QFVJpo-xJ4A/o.jpg",
 :is_closed=>false,
 :url=>"https://www.yelp.com/biz/another-broken-egg-cafe-college-station?adjust_creative=OGeha_o6Pn_MQscqLAAsMQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=OGeha_o6Pn_MQscqLAAsMQ",
 :review_count=>61,
 :categories=>[{:alias=>"breakfast_brunch", :title=>"Breakfast & Brunch"}, {:alias=>"cafes", :title=>"Cafes"}, {:alias=>"tradamerican", :title=>"American (Traditional)"}],
 :rating=>4.0,
 :coordinates=>{:latitude=>30.584043, :longitude=>-96.324335},
 :transactions=>["delivery"],
 :price=>"$$",
 :location=>
  {:address1=>"11655 Fm 2154 Bldg C1",
   :address2=>"Ste 100",
   :address3=>nil,
   :city=>"College Station",
   :ip_code=>"77845",
   :country=>"US",
   :state=>"TX",
   :display_address=>["11655 Fm 2154 Bldg C1", "Ste 100", "College Station, TX 77845"]},
 :phone=>"+19794859392",
 :display_phone=>"(979) 485-9392",
 :distance=>5892.058871216166}

=end

  def self.get_restaurant_details(id)
    url = "https://api.yelp.com/v3/businesses/#{id}"

    options = {
      headers: {
        Authorization: "Bearer #{ENV["YELP_API_KEY"]}"
      }
    }

    begin
      return HTTParty.get(url, options).parsed_response.deep_symbolize_keys
    rescue Exception => e
      puts e
    end
  end

  def self.update_details_for_restaurants
    restaurants = Restaurant.where.not(yelp_id: nil)
    rest_count = restaurants.count
    counter = 0
    restaurants.each do |restaurant|
      data = self.get_restaurant_details(restaurant.yelp_id)
      restaurant.yelp_rating = data[:rating]
      restaurant.yelp_review_count = data[:review_count]
      restaurant.primary_phone_number = data[:display_phone]
      restaurant.save!
      counter += 1
      puts "updated #{counter} out of #{rest_count}"
    end
  end

=begin
{:id=>"rOfX5ve4f1PbShG-H6d5Fw",
 :alias=>"mess-college-station",
 :name=>"MESS",
 :image_url=>
  "https://s3-media3.fl.yelpcdn.com/bphoto/1hq0qCzH0jOmB3bk-84Qxw/o.jpg",
 :is_claimed=>true,
 :is_closed=>false,
 :url=>
  "https://www.yelp.com/biz/mess-college-station?adjust_creative=OGeha_o6Pn_MQscqLAAsMQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=OGeha_o6Pn_MQscqLAAsMQ",
 :phone=>"+19797045200",
 :display_phone=>"(979) 704-5200",
 :review_count=>153,
 :categories=>
  [{:alias=>"tradamerican", :title=>"American (Traditional)"},
   {:alias=>"breakfast_brunch", :title=>"Breakfast & Brunch"},
   {:alias=>"comfortfood", :title=>"Comfort Food"}],
 :rating=>4.5,
 :location=>
  {:address1=>"170 Century Square Dr",
   :address2=>"Ste 10",
   :address3=>nil,
   :city=>"College Station",
   :zip_code=>"77840",
   :country=>"US",
   :state=>"TX",
   :display_address=>
    ["170 Century Square Dr", "Ste 10", "College Station, TX 77840"],
   :cross_streets=>""},
 :coordinates=>{:latitude=>30.62631622008178, :longitude=>-96.33802467389921},
 :photos=>
  ["https://s3-media3.fl.yelpcdn.com/bphoto/1hq0qCzH0jOmB3bk-84Qxw/o.jpg",
   "https://s3-media4.fl.yelpcdn.com/bphoto/QYBzpm8sdApe9Awmir_4Mg/o.jpg",
   "https://s3-media4.fl.yelpcdn.com/bphoto/a-bn3KSlOyuWGSCHHTfNqQ/o.jpg"],
 :price=>"$",
 :hours=>
  [{:open=>
     [{:is_overnight=>false, :start=>"0800", :end=>"1400", :day=>0},
      {:is_overnight=>false, :start=>"0800", :end=>"1400", :day=>1},
      {:is_overnight=>false, :start=>"0800", :end=>"1400", :day=>2},
      {:is_overnight=>false, :start=>"0800", :end=>"1400", :day=>3},
      {:is_overnight=>false, :start=>"0800", :end=>"1400", :day=>4},
      {:is_overnight=>false, :start=>"0800", :end=>"1400", :day=>5},
      {:is_overnight=>false, :start=>"0800", :end=>"1400", :day=>6}],
    :hours_type=>"REGULAR",
    :is_open_now=>true}],
 :transactions=>["pickup", "delivery"],
 :messaging=>
  {:url=>
    "https://www.yelp.com/raq/rOfX5ve4f1PbShG-H6d5Fw?adjust_creative=OGeha_o6Pn_MQscqLAAsMQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=OGeha_o6Pn_MQscqLAAsMQ#popup%3Araq",
   :use_case_text=>"Message the Business"}}
=end

end
