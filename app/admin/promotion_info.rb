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
    column :roles do |role|
      role.admin_users
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      table_for role.admin_user_roles do
        column "Admin Users" do |admin_user_role|
          admin_user_role.admin_user
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :name
      f.input :description
    end
    f.inputs 'Roles' do
      f.has_many :admin_user_roles, heading: false,
                              remove_record: true do |a|
        a.input :role_id, :input_html => { :value => f.object.id }, as: :hidden
        a.input :admin_user

      end
    end
    f.actions
  end
end
