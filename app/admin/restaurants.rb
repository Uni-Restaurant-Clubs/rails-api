ActiveAdmin.register Restaurant do

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

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :address do |restaurant|
      restaurant.address.try(:geocoded_address)
    end
    column :street_name do |restaurant|
      restaurant.address.try(:street_name)
    end
    column :status
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :status
      row :description
      row :notes
      row :address do |restaurant|
        restaurant.address.try(:geocoded_address)
      end
      row :street_name do |restaurant|
        restaurant.address.try(:street_name)
      end

      row :scheduled_review_date_and_time
      row :manager_info
      row :primary_phone_number
      row :primary_email
      row :other_contact_info
      row :website_url
      row :google_url
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :name
      f.input :description
      f.input :status
      f.input :notes
      f.input :scheduled_review_date_and_time, as: :datepicker
      f.input :manager_info
      f.input :primary_phone_number
      f.input :primary_email
      f.input :other_contact_info
      f.input :website_url
      f.input :google_url
    end
    f.inputs 'Address' do
      f.has_many :address, heading: false,
                              remove_record: false do |a|
        a.input :instructions
        a.input :apt_suite_number
        a.input :street_number
        a.input :street_name, label: "Street Name. Add type; street, avenue, circle ...)"
        a.input :city
        a.input :state
        a.input :country
        a.input :zipcode
      end
    end
    f.actions
  end
end
