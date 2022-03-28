ActiveAdmin.register PromotionInfo do
  actions :all, :except => [:destroy]
  permit_params do
    [:restaurant_status, :notes, :restaurant_responded_at]
  end

  scope :all do |infos|
    infos
  end
  scope :need_to_send_review_is_up_email do |infos|
    infos.where(restaurant_status: :need_to_send_review_is_up_email)
  end
  scope :need_to_post_to_instagram do |infos|
    infos.where(restaurant_status: :need_to_post_to_instagram)
  end
  scope :need_to_send_promo_intro_email do |infos|
    infos.where(restaurant_status: :need_to_send_promo_intro_email)
  end
  scope :sent_promotional_intro_email do |infos|
    infos.sent_promotional_intro_email_within_last_seven_days
  end
  scope :sent_promotional_intro_email_more_than_seven_days_ago do |infos|
    infos.where(restaurant_status: :sent_promotional_intro_email)
      .where("promotion_intro_email_sent_at < ?",  (TimeHelpers.now - 7.days))
  end

  scope :interested do |infos|
    infos.where(restaurant_status: :interested)
  end
  scope :ready_to_be_featured do |infos|
    infos.where(restaurant_status: :ready_to_be_featured)
  end
  scope :being_featured do |infos|
    infos.where(restaurant_status: :being_featured)
  end
  scope :previously_featured do |infos|
    infos.where(restaurant_status: :previously_featured)
  end
  scope :not_interested do |infos|
    infos.where(restaurant_status: :not_interested)
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
      row :review_is_up_email_sent_at
      row :promotion_intro_email_sent_at
      row :restaurant_responded_at
      row :follow_up_email_sent_at
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
      f.input :review_is_up_email_sent_at, as: :date_time_picker
      f.input :promotion_intro_email_sent_at, as: :date_time_picker
      f.input :restaurant_responded_at, as: :date_time_picker
      f.input :follow_up_email_sent_at, as: :date_time_picker
      f.input :notes
    end
    f.actions
  end
end
