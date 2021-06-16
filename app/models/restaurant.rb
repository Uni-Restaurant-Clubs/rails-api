class Restaurant < ApplicationRecord

  has_one :address, dependent: :destroy

  validates_presence_of [:name, :status]
  validates_uniqueness_of :google_place_id, allow_nil: true

  enum status: { not_contacted: 0, contacted_needs_follow_up: 1, declined: 2,
                 accepted: 3, review_scheduled: 4, reviewed: 5, archived: 6 }

  accepts_nested_attributes_for :address, :allow_destroy => true

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
