ActiveAdmin.register PromotionInfo do
  actions :all, :except => [:destroy]
  permit_params do
    [:restaurant_status, :notes, :restaurant_responded_at]
  end

  member_action :create_feature_period, method: :post do
    if !current_admin_user
      redirect_to resource_path(resource), alert: "Not Authorized"
    else
      response, error, promotion_info = FeaturePeriod.create_from_restaurant(resource.restaurant)
      if error
        redirect_to admin_promotion_info_path(resource.restaurant), alert: response
      else
        redirect_to admin_feature_period_path(promotion_info.id), notice: response
      end
    end
  end

  index do
    selectable_column
    id_column
    column :restaurant do |promotion_info|
      link_to promotion_info.restaurant.name, admin_restaurant_path(promotion_info.restaurant.id)
    end
    column :restaurant_status
    column :promotion_intro_email_sent_at
    column :restaurant_responded_at
    column :notes
    actions
  end

  show do
    attributes_table do
      row :restaurant do |promotion_info|
        link_to promotion_info.restaurant.name, admin_restaurant_path(promotion_info.restaurant.id)
      end

      row :restaurant_status
      row :promotion_intro_email_sent_at
      row :restaurant_responded_at
      row :create_feature_period do |restaurant|
        button_to "Create feature period for restaurant",
          create_feature_period_admin_promotion_info_path(restaurant.id),
          action: :post,
          :data => {:confirm => 'Are you sure you want to create a feature period for this restaurant?'}
      end

      row :notes
    end
  end

  form do |f|
    f.inputs "details" do
      f.semantic_errors *f.object.errors.keys
      f.input :restaurant_status
      f.input :notes
    end
    f.actions
  end
end
