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

  member_action :send_review_is_up_email, method: :post do
    if !current_admin_user
      redirect_to resource_path(resource), alert: "Not Authorized"
    else
      response, error = resource.send_review_is_up_email(current_admin_user.id)
      if error
        redirect_to resource_path(resource), alert: response
      else
        redirect_to admin_review_path(resource.id), notice: response
      end
    end
  end

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
      row :review_is_up_email_sent_at
      row :review_is_up_email_sent_by_admin_user_id do |review|
        if review.review_is_up_email_sent_by_admin_user_id
          admin_user = AdminUser.find_by(id: review.review_is_up_email_sent_by_admin_user_id)
          link_to admin_user.name, admin_admin_user_path(admin_user.id)
        end
      end
      row :send_review_is_up_email do |review|
        if review.review_is_up_email_sent_at
          "Email already sent"
        else
          button_to "Send review is up email",
            send_review_is_up_email_admin_review_path(review.id),
            action: :post,
            :data => {:confirm => 'Are you sure you want to send the review is up email for this restaurant?'}
        end
      end
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
