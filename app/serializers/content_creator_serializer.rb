class ContentCreatorSerializer < ActiveModel::Serializer
  attributes :creator_type, :name,
             :linkedin_url, :facebook_url, :instagram_url, :website_url,
             :bio, :photo, :public_unique_username, :youtube_url

  def photo
    if object.image
      object.image.resize_to_fit(1000).try(:processed).try(:url)
    end
  end

  class ReviewSerializer < ActiveModel::Serializer
    attributes :id, :reviewed_at, :article_title, :featured_photo

    belongs_to :restaurant

    class RestaurantSerializer < ActiveModel::Serializer
      attributes :name
    end

  end


end
