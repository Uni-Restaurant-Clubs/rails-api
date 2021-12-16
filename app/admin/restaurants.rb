ActiveAdmin.register Restaurant do

  controller do
    def find_collection(options = {})
      super.brooklyn.reorder(yelp_rating: :desc, yelp_review_count: :desc)
    end
  end

  actions :all, :except => [:destroy]

  permit_params do
    permitted = [:name, :description, :address_id, :manager_info,
                :primary_phone_number, :primary_email, :other_contact_info,
                :operational_status, :website_url, :is_franchise,
                :managers, :status, :notes, :scheduled_review_date_and_time,
                :starred, :urc_rating, :follow_up_reason, :accepted_at,
                :option_1, :option_2, :option_3, :initial_offer_sent_to_creators,
                :writer_confirmed, :photographer_confirmed,
                :restaurant_confirmed_final_time,
                :confirmed_with_restaurant_day_of_review,
                :confirmed_with_writer_day_of_review,
                :confirmed_with_photographer_day_of_review,
                :photographer_handed_in_photos, :date_photos_received,
                :writer_handed_in_article,
                :confirmed_with_restaurant_three_days_before,
                :confirmed_with_creators_day_before,
                :date_article_received, :photographer_id, :writer_id,
                address_attributes: [:id, :apt_suite_number, :street_number,
                                       :street_name, :street_type, :city,
                                       :state, :country, :zipcode,
                                       :instructions]]
    #permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  preserve_default_filters!
  filter :follow_up_reason, as: :select, collection: Restaurant.follow_up_reasons
  filter :status, as: :select, collection: Restaurant.statuses
  filter :operational_status, as: :select,
         collection: Restaurant.operational_statuses
  filter :urc_rating, as: :select, collection: Restaurant.urc_ratings

  scope :all do |restaurants|
    restaurants.brooklyn
  end
  scope :non_franchise_starred, :default => true do |restaurants|
    restaurants.brooklyn.where(is_franchise: false, starred: true)
  end
  scope :non_franchise do |restaurants|
    restaurants.brooklyn.where(:is_franchise => false)
  end
  scope :franchise do |restaurants|
    restaurants.brooklyn.where(:is_franchise => true)
  end

  member_action :create_review, method: :post do
    if !current_admin_user
      redirect_to resource_path(resource), alert: "Not Authorized"
    else
      response, error, review = Review.create_from_restaurant(resource)
      if error
        redirect_to resource_path(resource), alert: response
      else
        redirect_to admin_review_path(review.id), notice: response
      end
    end
  end

  member_action :send_review_offer_emails, method: :post do
    if !current_admin_user
      redirect_to resource_path(resource), alert: "Not Authorized"
    else
      response, error = CreatorReviewOffer.create_offers_and_send_emails_to_creators(
                                                                       resource)
      if error
        redirect_to resource_path(resource), alert: response
      else
        redirect_to resource_path(resource), notice: response
      end
    end
  end

  member_action :unschedule_restaurant_review, method: :post do
    if !current_admin_user
      redirect_to resource_path(resource), alert: "Not Authorized"
    else
      response, error = resource.reset_confirmation_information_so_can_resend_initial_offers
      if error
        redirect_to resource_path(resource), alert: response
      else
        redirect_to resource_path(resource), notice: response
      end
    end
  end

  index :download_links => false do
    selectable_column
    id_column
    column :name
    column :status do |restaurant|
      restaurant.status.humanize.downcase
    end
    column :follow_up_reason
    column :primary_phone_number
    column :starred do |restaurant|
      if restaurant.starred
        image_tag "https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/282/star_2b50.png", style: 'height:20px;width:auto;'
      end
    end
    column :urc_rating
    column :yelp_rating
    column :yelp_review_count
    column :is_franchise
    column :yelp_url do |restaurant|
        link_to "Yelp URL", restaurant.yelp_url, target: "_blank"
    end
    column "Image" do |restaurant|
      if restaurant.image_url
        image_tag restaurant.image_url, style: 'height:100px;width:auto;'
      end
    end
    column "city, state" do |restaurant|
      restaurant.address.try(:city_state)
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :yelp_alias
      row :status do |restaurant|
        restaurant.status.humanize.downcase
      end
      row :follow_up_reason
      row :operational_status
      row :starred
      row :urc_rating
      row :yelp_rating
      row :yelp_review_count
      row :is_franchise
      row "Yelp Url" do |restaurant|
          link_to "Yelp URL", restaurant.yelp_url, target: "_blank"
      end
      row :description
      row "Image" do |restaurant|
        if restaurant.image_url
          image_tag restaurant.image_url, style: 'height:300px;width:auto;'
        end
      end
      row :notes
      row :address do |restaurant|
        restaurant.address.try(:full_address)
      end
      row :manager_info
      row :primary_phone_number
      row :primary_email
      row :other_contact_info
      row :website_url
      row :unschedule_restaurant_review do |restaurant|
        button_to "Unschedule Restaurant Review so that it can be Rescheduled",
          unschedule_restaurant_review_admin_restaurant_path(restaurant.id),
          action: :post,
          :data => {:confirm => 'Are you sure you want to UNSCHEDULE the restaurant review? This will set status to accepted and remove scheduled_review_date_and_time so that the restaurant can be RESCHEDULED again'}
      end
      row :scheduled_review_date_and_time
      row :restaurant_event_url
      row :creators_event_url
      row :accepted_at
      row :option_1
      row :option_2
      row :option_3
      row :create_review do |restaurant|
        button_to "Create a review for this restaurant",
          create_review_admin_restaurant_path(restaurant.id),
          action: :post,
          :data => {:confirm => 'Are you sure you want to create a review for this restaurant?'}
      end
      row :send_review_offer_emails_to_creators do |restaurant|
        button_to "Send review offer emails to creators",
          send_review_offer_emails_admin_restaurant_path(restaurant.id),
          action: :post,
          :data => {:confirm => 'Are you sure you want to send review offer emails out to creators?'}
      end
      row :initial_offer_sent_to_creators
      row :offer_sent_to_everyone
      row :writer_confirmed
      row :photographer_confirmed
      row :restaurant_confirmed_final_time
      row :confirmed_with_restaurant_three_days_before
      row :confirmed_with_creators_day_before
      row :confirmed_with_restaurant_day_of_review
      row :confirmed_with_writer_day_of_review
      row :confirmed_with_photographer_day_of_review
      row :photographer_handed_in_photos
      row :date_photos_received
      row :writer_handed_in_article
      row :date_article_received
      row :photographer
      row :writer

    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :name
      f.input :description
      f.input :is_franchise
      f.input :status
      f.input :follow_up_reason
      f.input :operational_status
      f.input :starred
      f.input :urc_rating
      f.input :notes
      f.input :manager_info
      f.input :primary_phone_number
      f.input :primary_email
      f.input :other_contact_info
      f.input :website_url
      f.input :accepted_at, as: :date_time_picker
      f.input :option_1, as: :date_time_picker
      f.input :option_2, as: :date_time_picker
      f.input :option_3, as: :date_time_picker
      f.input :initial_offer_sent_to_creators
      f.input :writer_confirmed
      f.input :photographer_confirmed
      f.input :restaurant_confirmed_final_time
      f.input :scheduled_review_date_and_time, as: :date_time_picker
      f.input :confirmed_with_restaurant_three_days_before
      f.input :confirmed_with_creators_day_before
      f.input :confirmed_with_restaurant_day_of_review
      f.input :confirmed_with_writer_day_of_review
      f.input :confirmed_with_photographer_day_of_review
      f.input :photographer_handed_in_photos
      f.input :date_photos_received, as: :date_time_picker
      f.input :writer_handed_in_article
      f.input :date_article_received, as: :date_time_picker
      f.input :photographer
      f.input :writer
    end
    f.inputs 'Address' do
      f.has_many :address, heading: false,
                              remove_record: false do |a|
        a.input :instructions
      end
    end
    f.actions
  end
end
