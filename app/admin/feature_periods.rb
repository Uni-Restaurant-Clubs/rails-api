ActiveAdmin.register FeaturePeriod do
  actions :all, :except => [:destroy]
  permit_params do
    permitted = [
      :discount_type, :discount_number, :status, :start_date, :end_date,
      :disclaimers, :perks, :notes, :restaurant_id, :two_for_one_item
    ]
    #permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  index download_links: proc{ current_admin_user.email == "monty@unirestaurantclubs.com" } do
    selectable_column
    id_column
    column :restaurant
    column :discount_type
    column :two_for_one_item
    column :discount_number do |feature_period|
      feature_period.readable_deal
    end
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
      row :two_for_one_item
      row :discount_number do |feature_period|
        feature_period.readable_deal
      end
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
      f.input :two_for_one_item, label: "2 for 1 item. Example put 'drinks' and it will show '2 for 1 drinks!' to the members"
      f.input :discount_number, label: "If dollar amount, add total cents. Example: for $20.50, the amount entered should be 2000 since $20.50 is 2000 cents"
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
