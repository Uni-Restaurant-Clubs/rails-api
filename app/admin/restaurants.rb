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
                :confirmed_with_creators_day_before, :preferred_contact_method,
                :instagram_username, :cellphone_number, :contacted_by,
                :restaurant_replied_through, :date_we_contacted_them,
                :date_restaurant_replied, :facebook_username, :did_we_phone_them,
                :did_we_instagram_message_them, :did_we_facebook_message_them,
                :did_we_email_them, :did_we_contact_them_through_website,
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

  member_action :create_scheduling_form_url, method: :post do
    if !current_admin_user
      redirect_to resource_path(resource), alert: "Not Authorized"
    else
      response, error = resource.create_scheduling_form_url
      if error
        redirect_to resource_path(resource), alert: response
      else
        redirect_to admin_restaurant_path(resource.id), notice: response
      end
    end
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

  member_action :create_feature_period, method: :post do
    if !current_admin_user
      redirect_to resource_path(resource), alert: "Not Authorized"
    else
      response, error, review = FeaturePeriod.create_from_restaurant(resource)
      if error
        redirect_to resource_path(resource), alert: response
      else
        redirect_to admin_feature_period_path(review.id), notice: response
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

  index download_links: proc{ current_admin_user.email == "monty@unirestaurantclubs.com" } do
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

  show do |restaurant|
    columns do
      column do
        panel "Basic Info" do
          attributes_table_for restaurant do
            row :name
            row :yelp_alias
            row :status do |restaurant|
              restaurant.status.humanize.downcase
            end
            row :notes
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
                image_tag restaurant.image_url, style: 'height:200px;width:auto;'
              end
            end
            row :address do |restaurant|
              restaurant.address.try(:full_address)
            end
            row :photographer
            row :writer
          end
        end
      end
      column do
        panel "Contact Info" do
          attributes_table_for restaurant do
            row :manager_info
            row :preferred_contact_method
            row :primary_phone_number
            row :cellphone_number
            row :primary_email
            row :other_contact_info
            row :website_url
            row :instagram_username
            row :facebook_username
          end
        end
        panel 'Outreach' do
          attributes_table_for restaurant do
            row :contacted_by
            row :follow_up_reason
            row :did_we_phone_them
            row :did_we_instagram_message_them
            row :did_we_facebook_message_them
            row :did_we_email_them
            row :did_we_contact_them_through_website
            row :date_we_contacted_them
            row :date_restaurant_replied
            row :restaurant_replied_through
            row :submitted_scheduling_form_at do |res|
              TimeHelpers.to_human(res.submitted_scheduling_form_at)
            end
            row :scheduling_form_url
            row :scheduling_form_url_created_at do |restaurant|
              TimeHelpers.to_human(restaurant.scheduling_token_created_at) ||
                "never created"
            end
            row :create_scheduling_form_url do |restaurant|
              button_to "Create a Scheduling Form URL for this restaurant",
                create_scheduling_form_url_admin_restaurant_path(restaurant.id),
                action: :post,
                :data => {:confirm => 'Are you sure you want to create a scheduling form URL for this restaurant?'}
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Review Scheduling" do
          attributes_table_for restaurant do
            row :accepted_at
            row :last_time_a_review_related_date_was_updated
            row :unschedule_restaurant_review do |restaurant|
              button_to "Unschedule Review so can be Rescheduled",
                unschedule_restaurant_review_admin_restaurant_path(restaurant.id),
                action: :post,
                :data => {:confirm => 'Are you sure you want to UNSCHEDULE the restaurant review? This will set status to accepted and remove scheduled_review_date_and_time so that the restaurant can be RESCHEDULED again'}
            end
            row :scheduled_review_date_and_time
            row :restaurant_event_url
            row :creators_event_url
            row :option_1
            row :option_2
            row :option_3
            row :send_review_offer_emails_to_creators do |restaurant|
              button_to "Send review offer emails to creators",
                send_review_offer_emails_admin_restaurant_path(restaurant.id),
                action: :post,
                :data => {:confirm => 'Are you sure you want to send review offer emails out to creators?'}
            end
            row :initial_offer_sent_to_creators
            row :offer_sent_to_everyone
          end
        end
      end
      column do
        panel "Confirmations" do
          attributes_table_for restaurant do
            row :restaurant_confirmed_final_time
            row :confirmed_with_restaurant_three_days_before
            row :confirmed_with_creators_day_before
            row :confirmed_with_restaurant_day_of_review
            row :confirmed_with_writer_day_of_review
            row :confirmed_with_photographer_day_of_review
          end
        end
      end
      column do
        panel 'After review is finished' do
          attributes_table_for restaurant do
            row :photographer_handed_in_photos
            row :date_photos_received
            row :writer_handed_in_article
            row :date_article_received
            row :create_review do |restaurant|
              button_to "Create a review for this restaurant",
                create_review_admin_restaurant_path(restaurant.id),
                action: :post,
                :data => {:confirm => 'Are you sure you want to create a review for this restaurant?'}
            end
            row :create_feature_period do |restaurant|
              button_to "Create feature period for restaurant",
                create_feature_period_admin_restaurant_path(restaurant.id),
                action: :post,
                :data => {:confirm => 'Are you sure you want to create a feature period for this restaurant?'}
            end
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    columns do
      column do
        f.inputs "Basic Info" do
          f.input :name
          f.input :status
          f.input :notes
          f.input :operational_status
          f.input :starred
          f.input :urc_rating
          f.input :is_franchise
          f.input :description
          f.input :photographer
          f.input :writer
        end
      end
      column do
        f.inputs "Contact Info" do
          f.input :manager_info
          f.input :preferred_contact_method
          f.input :primary_phone_number
          f.input :cellphone_number
          f.input :primary_email
          f.input :other_contact_info
          f.input :website_url
          f.input :instagram_username
          f.input :facebook_username
        end
      end
    end
    columns do
      column do
        f.inputs "Outreach" do
          f.input :contacted_by
          f.input :follow_up_reason
          f.input :did_we_phone_them
          f.input :did_we_instagram_message_them
          f.input :did_we_facebook_message_them
          f.input :did_we_email_them
          f.input :did_we_contact_them_through_website
          f.input :date_we_contacted_them, as: :date_time_picker
          f.input :date_restaurant_replied, as: :date_time_picker
          f.input :restaurant_replied_through
        end
      end
      column do
        f.inputs "Review Scheduling" do
          f.input :scheduled_review_date_and_time, as: :date_time_picker
          f.input :option_1, as: :date_time_picker
          f.input :option_2, as: :date_time_picker
          f.input :option_3, as: :date_time_picker
        end
      end
    end
    columns do
      column do
        f.inputs "Confirmations" do
          f.input :restaurant_confirmed_final_time
          f.input :confirmed_with_restaurant_three_days_before
          f.input :confirmed_with_creators_day_before
          f.input :confirmed_with_restaurant_day_of_review
          f.input :confirmed_with_writer_day_of_review
          f.input :confirmed_with_photographer_day_of_review
        end
      end
      column do
        f.inputs "After review is finished" do
          f.input :photographer_handed_in_photos
          f.input :date_photos_received, as: :date_time_picker
          f.input :writer_handed_in_article
          f.input :date_article_received, as: :date_time_picker
        end
      end
    end
    f.actions
  end
end
