ActiveAdmin.register FeaturePeriod do
  actions :all, :except => [:destroy]
  permit_params do
    permitted = [
      :discount_type, :discount_number, :status, :start_date, :end_date,
      :disclaimers, :perks, :notes, :restaurant_id
    ]
    #permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  index download_links: proc{ current_admin_user.email == "monty@unirestaurantclubs.com" } do
    selectable_column
    id_column
    column :restaurant
    column :discount_type
    column :discount_number
    column :status
    column :start_date
    column :end_date
    column :disclaimers
    column :perks
    column :notes
    actions
  end

  show do |restaurant|
    attributes_table_for restaurant do
      row :discount_type
      row :discount_number
      row :status
      row :start_date
      row :end_date
      row :disclaimers
      row :perks
      row :notes
      row :restaurant
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :discount_type
      f.input :discount_number
      f.input :status
      f.input :start_date, as: :date_time_picker
      f.input :end_date, as: :date_time_picker
      f.input :disclaimers
      f.input :perks
      f.input :notes
    end
    f.actions
  end

end
