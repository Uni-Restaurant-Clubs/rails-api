class TravelAdvisor

  # https://rapidapi.com/apidojo/api/travel-advisor/
  def self.get_restaurants_subset(lat_lng, offset=0)
    # lat long for Beverly Estates Bryan, TX 77802
    lat = lat_lng[0]
    lng = lat_lng[1]
    meter_radius = "10" #1 mile
    url = "https://travel-advisor.p.rapidapi.com/restaurants/list-by-latlng?" +
    "latitude=#{lat}&" +
    "longitude=#{lng}&" +
    "radius=#{meter_radius}&" +
    "lunit=mi&" +
    "limit=30&" +
    "offset=#{offset}&"

    options = {
      headers: {
        "X-Rapidapi-Key" => ENV["TRIP_ADVISOR_API_KEY"],
        "X-Rapidapi-Host" => "travel-advisor.p.rapidapi.com"
      }
    }

    begin
      return HTTParty.get(url, options).parsed_response.deep_symbolize_keys
    rescue Exception => e
      puts e
    end
  end

  # only returned 293
  def self.get_all_restaurant_ids
    # maximum of 10 mile radius so need diff points
    lat_lng_pairs = [
      ["30.574590", "-96.272607"],
      ["30.625566", "-96.335607"],
      ["30.671643", "-96.379552"]
    ]
    restaurant_ids = []
    lat_lng_pairs.each do |lat_lng|
      puts "new lat_lng pair"
      restaurants_left = true
      while restaurants_left
        offset = restaurant_ids.count
        data = self.get_restaurants_subset(lat_lng, offset)
        puts "new data"
        puts data[:data].length
        if data[:data].any?
          data[:data].each do |restaurant|
            restaurant_ids << restaurant[:location_id]
            puts "restaurant ids length"
            puts restaurant_ids.length
          end
        else
          restaurants_left = false
        end
      end
    end
    return restaurant_ids.uniq
  end

=begin
=> {:location_id=>"10470665",
 :name=>"First Watch",
 :latitude=>"30.631405",
 :longitude=>"-96.33815",
 :num_reviews=>"121",
 :timezone=>"America/Chicago",
 :location_string=>"Bryan, Texas",
 :photo=>
  {:images=>
      {:small=>{:width=>"150", :url=>"https://media-cdn.tripadvisor.com/media/photo-l/0b/d5/e1/02/photo1jpg.jpg", :height=>"150"},
           :thumbnail=>{:width=>"50", :url=>"https://media-cdn.tripadvisor.com/media/photo-t/0b/d5/e1/02/photo1jpg.jpg", :height=>"50"},
           :original=>{:width=>"2048", :url=>"https://media-cdn.tripadvisor.com/media/photo-o/0b/d5/e1/02/photo1jpg.jpg", :height=>"1536"},
           :large=>{:width=>"550", :url=>"https://media-cdn.tripadvisor.com/media/photo-s/0b/d5/e1/02/photo1jpg.jpg", :height=>"413"},
           :medium=>{:width=>"250", :url=>"https://media-cdn.tripadvisor.com/media/photo-f/0b/d5/e1/02/photo1jpg.jpg", :height=>"188"}},
     :is_blessed=>true,
     :uploaded_date=>"2016-07-03T13:02:18-0400",
     :caption=>"",
     :id=>"198566146",
     :helpful_votes=>"0",
     :published_date=>"2016-07-03T13:02:18-0400",
     :user=>{:user_id=>nil, :member_id=>"0", :type=>"user"}},
 :awards=>
  [{:award_type=>"CERTIFICATE_OF_EXCELLENCE",
      :year=>"2020",
      :images=>
       {:small=>"https://www.tripadvisor.com/img/cdsi/img2/awards/CERTIFICATE_OF_EXCELLENCE_small-0-5.jpg",
             :large=>"https://www.tripadvisor.com/img/cdsi/img2/awards/CERTIFICATE_OF_EXCELLENCE_2020_en_US_large-0-5.jpg"},
      :categories=>[],
      :display_name=>"Certificate of Excellence 2020"},
     {:award_type=>"CERTIFICATE_OF_EXCELLENCE",
           :year=>"2019",
           :images=>
            {:small=>"https://www.tripadvisor.com/img/cdsi/img2/awards/CERTIFICATE_OF_EXCELLENCE_small-0-5.jpg",
                  :large=>"https://www.tripadvisor.com/img/cdsi/img2/awards/CERTIFICATE_OF_EXCELLENCE_2019_en_US_large-0-5.jpg"},
           :categories=>[],
           :display_name=>"Certificate of Excellence 2019"},
     {:award_type=>"CERTIFICATE_OF_EXCELLENCE",
                :year=>"2018",
                :images=>
                 {:small=>"https://www.tripadvisor.com/img/cdsi/img2/awards/CERTIFICATE_OF_EXCELLENCE_small-0-5.jpg",
                       :large=>"https://www.tripadvisor.com/img/cdsi/img2/awards/CERTIFICATE_OF_EXCELLENCE_2018_en_US_large-0-5.jpg"},
                :categories=>[],
                :display_name=>"Certificate of Excellence 2018"}],
 :doubleclick_zone=>"na.us.texas",
 :preferred_map_engine=>"default",
 :raw_ranking=>"3.704035758972168",
 :ranking_geo=>"Bryan",
 :ranking_geo_id=>"55543",
 :ranking_position=>"7",
 :ranking_denominator=>"158",
 :ranking_category=>"restaurant",
 :ranking=>"#5 of 167 Restaurants in Bryan",
 :distance=>"0.37535322398495097",
 :distance_string=>"0.4 mi",
 :bearing=>"southwest",
 :rating=>"4.0",
 :is_closed=>false,
 :is_long_closed=>false,
 :price_level=>"$$ - $$$",
 :price=>"$8 - $12",
 :description=>
  "First Watch specializes in delicious Breakfast, Brunch and Lunch creations freshly-prepared to order. First Watch begins each morning at the crack of dawn, slicing and juicing fresh fruits and vegetables, baking muffins and making French toast batter from scratch. Free WiFi & newspapers are available.",
 :web_url=>"https://www.tripadvisor.com/Restaurant_Review-g55543-d10470665-Reviews-First_Watch-Bryan_Texas.html",
 :write_review=>"https://www.tripadvisor.com/UserReview-g55543-d10470665-First_Watch-Bryan_Texas.html",
 :ancestors=>
  [{:subcategory=>[{:key=>"city", :name=>"City"}], :name=>"Bryan", :abbrv=>nil, :location_id=>"55543"},
     {:subcategory=>[{:key=>"state", :name=>"State"}], :name=>"Texas", :abbrv=>"TX", :location_id=>"28964"},
     {:subcategory=>[{:key=>"country", :name=>"Country"}], :name=>"United States", :abbrv=>nil, :location_id=>"191"}],
 :category=>{:key=>"restaurant", :name=>"Restaurant"},
 :subcategory=>[{:key=>"cafe", :name=>"Café"}],
 :parent_display_name=>"Bryan",
 :is_jfy_enabled=>false,
 :nearest_metro_station=>[],
 :reviews=>
  [{:id=>"788620432",
      :lang=>nil,
      :location_id=>"0",
      :published_date=>"2021-06-27T10:01:15-04:00",
      :published_platform=>"Desktop",
      :rating=>"5",
      :type=>"review",
      :helpful_votes=>"0",
      :url=>"https://www.tripadvisor.com/ShowUserReviews?src=788620432#review788620432",
      :travel_date=>nil,
      :text=>nil,
      :user=>nil,
      :title=>"First Watch Breakfast Anytime",
      :owner_response=>nil,
      :subratings=>[],
      :machine_translated=>false,
      :machine_translatable=>false}],
 :phone=>"+1 979-704-6652",
 :website=>"http://www.firstwatch.com",
 :address_obj=>{:street1=>"4501 S Texas Ave", :street2=>nil, :city=>"Bryan", :state=>"TX", :country=>"United States", :postalcode=>"77802-4303"},
 :address=>"4501 S Texas Ave, Bryan, TX 77802-4303",
 :is_candidate_for_contact_info_suppression=>false,
 :cuisine=>
  [{:key=>"9908", :name=>"American"},
     {:key=>"10642", :name=>"Cafe"},
     {:key=>"10679", :name=>"Healthy"},
     {:key=>"10665", :name=>"Vegetarian Friendly"},
     {:key=>"10697", :name=>"Vegan Options"},
     {:key=>"10992", :name=>"Gluten Free Options"}],
 :dietary_restrictions=>[{:key=>"10665", :name=>"Vegetarian Friendly"}, {:key=>"10697", :name=>"Vegan Options"}, {:key=>"10992", :name=>"Gluten Free Options"}],
 :establishment_types=>[{:key=>"10591", :name=>"Restaurants"}]}


=end



end
