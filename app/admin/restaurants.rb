ActiveAdmin.register Restaurant do
  actions :all, :except => [:destroy]

  permit_params do
    permitted = [:name, :description, :address_id, :manager_info,
                :primary_phone_number, :primary_email, :other_contact_info,
                :managers, :status, :notes, :scheduled_review_date_and_time,
                :website_url, :google_url,
                address_attributes: [:id, :apt_suite_number, :street_number,
                                       :street_name, :street_type, :city,
                                       :state, :country, :zipcode,
                                       :instructions]]
    #permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  scope :all
  scope :non_franchise, :default => true do |restaurants|
    restaurants.where(:is_franchise => false)
  end
  scope :franchise do |restaurants|
    restaurants.where(:is_franchise => true)
  end
  index :download_links => false do
    selectable_column
    id_column
    column :name
    column :yelp_alias
    column :status
    column :is_franchise
    column :yelp_url do |restaurant|
        link_to "Yelp URL", restaurant.yelp_url, target: "_blank"
    end
    column "Image" do |restaurant|
        image_tag restaurant.image_url, style: 'height:100px;width:auto;'
    end
    column :description
    column :full_address do |restaurant|
      restaurant.address.try(:full_address)
    end
    column :primary_phone_number
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :yelp_alias
      row :status
      row :is_franchise
      row "Yelp Url" do |restaurant|
          link_to "Yelp URL", restaurant.yelp_url, target: "_blank"
      end
      row :description
      row "Image" do |restaurant|
        image_tag restaurant.image_url, style: 'height:300px;width:auto;'
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
      f.input :notes
      f.input :scheduled_review_date_and_time, as: :datepicker
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
