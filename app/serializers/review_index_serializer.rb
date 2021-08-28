class ReviewIndexSerializer < ActiveModel::Serializer
  attributes :id, :reviewed_at, :article_title,
             :featured_photo

  belongs_to :restaurant

  def article_title
    object.article_title&.capitalize
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

  class RestaurantSerializer < ActiveModel::Serializer
    attributes :name
  end

end
