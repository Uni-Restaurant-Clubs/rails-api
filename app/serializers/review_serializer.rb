class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :reviewed_at, :article, :photos, :article_title,
             :featured_photo, :featuring_info

  belongs_to :writer
  belongs_to :photographer
  belongs_to :restaurant

  def featuring_info
    feature = object.restaurant&.feature_periods.currently_featured&.feature_live&.last
    FeaturePeriodSerializer.new(feature) if feature
  end

  def article_title
    object.article_title&.capitalize
  end

  def photos
    object.images.map do |image|
      {
        id: image.id,
        name: image.title,
        photo: image.resize_to_fit(1000).try(:processed).try(:url)
      }
    end
  end

  def featured_photo
    photo = object.featured_photo
    if photo
      {
        id: photo.id,
        name: photo.title,
        photo: photo.resize_to_fit(1000).try(:processed).try(:url)
      }
    else
      { name: "", photo: "" }
    end
  end

  def article
    object.full_article
  end

  class ContentCreatorSerializer < ActiveModel::Serializer
    attributes :first_name, :last_name, :photo, :public_unique_username

    def photo
      if object.image
        object.image.resize_to_fit(1000).try(:processed).try(:url)
      end
    end

  end

  class RestaurantSerializer < ActiveModel::Serializer
    attributes :name, :id
  end

  class FeaturePeriodSerializer < ActiveModel::Serializer
    attributes :id, :perks, :deal

    def deal
      object.readable_deal
    end
  end

end
