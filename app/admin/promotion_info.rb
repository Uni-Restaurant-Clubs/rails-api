ActiveAdmin.register PromotionInfo do
  actions :all, :except => [:destroy]
  permit_params do
    [:restaurant_status, :notes, :restaurant_responded_at]
  end

  index do
    selectable_column
    id_column
    column :restaurant do |promotion_info|
      link_to promotion_info.restaurant, admin_restaurant_path(promotion_info.restaurant.id)
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
        link_to promotion_info.restaurant, admin_restaurant_path(promotion_info.restaurant.id)
      end

      row :restaurant_status
      row :promotion_intro_email_sent_at
      row :restaurant_responded_at
      row :notes
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.input :restaurant_status
    f.input :promotion_intro_email_sent_at
    f.input :restaurant_responded_at
    f.input :notes
    f.actions
  end
end
