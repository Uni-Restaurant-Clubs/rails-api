class Restaurant < ApplicationRecord

  has_one :address

  validates_presence_of [:name, :status]

  enum status: { added: 0, contacted_needs_follow_up: 1, declined: 2,
                 accepted: 3, review_scheduled: 4, reviewed: 5, archived: 6 }

  accepts_nested_attributes_for :address, :allow_destroy => true

  def self.get_google_restaurants
    # lat long for Beverly Estates Bryan, TX 77802
    lat = "30.6362"
    lng = "-96.3352"
    meter_radius = "16093" #10 miles
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?" +
    "location=#{lat},#{lng}&" +
    "radius=#{meter_radius}&" +
    "type=restaurant&" +
    "key=#{ENV["GOOGLE_API_KEY"]}"

    begin
      return HTTParty.get(url, {}).parsed_response
    rescue Exception => e
      puts e
    end
  end

  def self.import_google_restaurant_data
    self.get_google_restaurants
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

end
