ActiveAdmin.register Restaurant do

  controller do
    def find_collection(options = {})
      super.reorder(yelp_rating: :desc, yelp_review_count: :desc)
    end
  end

  actions :all, :except => [:destroy]

  permit_params do
    permitted = [:name, :description, :address_id, :manager_info,
                :primary_phone_number, :primary_email, :other_contact_info,
                :operational_status, :website_url, :is_franchise,
                :managers, :status, :notes, :scheduled_review_date_and_time,
                :starred, :urc_rating, :follow_up_reason,
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

  scope :all
  scope :non_franchise_starred, :default => true do |restaurants|
    restaurants.where(is_franchise: false, starred: true)
  end
  scope :non_franchise do |restaurants|
    restaurants.where(:is_franchise => false)
  end
  scope :franchise do |restaurants|
    restaurants.where(:is_franchise => true)
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
      row :scheduled_review_date_and_time
      row :manager_info
      row :primary_phone_number
      row :primary_email
      row :other_contact_info
      row :website_url
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
      f.input :scheduled_review_date_and_time, as: :date_time_picker
      f.input :manager_info
      f.input :primary_phone_number
      f.input :primary_email
      f.input :other_contact_info
      f.input :website_url
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
