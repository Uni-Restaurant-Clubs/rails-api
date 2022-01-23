class ContentCreatorSerializer < ActiveModel::Serializer
  attributes :creator_type, :name,
             :linkedin_url, :facebook_url, :instagram_url, :website_url,
             :bio, :photo, :public_unique_username, :youtube_url

  has_many :reviews

  def instagram_url
    if object.instagram_handle.present?
      return "https://www.instagram.com/#{object.instagram_handle}"
    else
      return nil
    end
  end

  def photo
    if object.image
      object.image.resize_to_fit(1000).try(:processed).try(:url)
    end
  end

  class ReviewSerializer < ActiveModel::Serializer
    attributes :id, :reviewed_at, :article_title, :photo, :restaurant_name

    def restaurant_name
      object.restaurant&.name
    end

    def photo
      object.featured_photo&.resize_to_fit(1000)&.processed&.url
    end

    class RestaurantSerializer < ActiveModel::Serializer
      attributes :name
    end

  end


end
