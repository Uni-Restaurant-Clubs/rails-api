ActiveAdmin.register Review do

  controller do
    def find_collection(options = {})
      super.unscoped.page(params[:page]).per(10)
    end

    def resource
      Review.unscoped { super }
    end

  end

  actions :all, :except => [:destroy, :new, :create]

  member_action :update_review, method: :post do
    if !current_admin_user
      redirect_to resource_path(resource), alert: "Not Authorized"
    else
      review_params = params.require(:review)
      response, error = resource.update_from_active_admin(review_params, current_admin_user.id)
      if error
        redirect_to resource_path(resource), alert: response
      else
        redirect_to admin_review_path(resource.id), notice: response
      end
    end
  end

  index do
    selectable_column
    id_column
    column :restaurant
    column :status
    column :quality_ranking
    column :writer
    column :photographer
    column :reviewed_at
    column :featured_image do |review|
      if review.images.featured.any?
        image_tag url_for(review.images.featured.first.resize_to_fit(100))
      end
    end
    actions
  end

  show do
    attributes_table do
      row :restaurant
      row :status
      row :quality_ranking
      row :writer
      row :photographer
      row :reviewed_at
      row :article_title
      row (:full_article) { |review| raw(review.full_article) }
      row (:medium_article) { |review| raw(review.medium_article) }
      row (:small_article) { |review| raw(review.small_article) }
      table_for review.images do
        column "Title" do |image|
          image.title
        end
        column "Featured" do |image|
          image.featured
        end
        column "Image" do |image|
          image.title
          image_tag url_for(image.resize_to_fit(800))
        end
      end
    end
  end

  form partial: 'review_images_form'

end
