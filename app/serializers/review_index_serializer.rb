class ReviewIndexSerializer < ActiveModel::Serializer
  attributes :id, :reviewed_at, :article_title,
             :featured_photo, :featuring_info

  belongs_to :restaurant

  def article_title
    object.article_title&.capitalize
  end

  def featuring_info
    feature = object.restaurant&.feature_periods.currently_featured&.feature_live&.last
    FeaturePeriodSerializer.new(feature) if feature
  end

  def featured_photo
    photo = object.featured_photo
    if photo
      {
        name: photo.title,
        photo: photo.resize_to_fit(1000).try(:processed).try(:url)
      }
    else
      { name: "", photo: "" }
    end
  end

  class FeaturePeriodSerializer < ActiveModel::Serializer
    attributes :discount_type, :discount_number, :status, :start_date, :end_date,
      :disclaimers, :perks, :deal

    def deal
      object.readable_deal
    end
  end

  class RestaurantSerializer < ActiveModel::Serializer
    attributes :name
  end

end
