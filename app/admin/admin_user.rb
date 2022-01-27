ActiveAdmin.register AdminUser do
  actions :all, :except => [:destroy]
  permit_params do
    [:first_name, :last_name,
     admin_user_roles_attributes: [:id, :admin_user_id, :role_id]]
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :roles do |admin|
      admin.roles
    end
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      table_for admin_user.admin_user_roles do
        column "Roles" do |admin_user_role|
          admin_user_role.role
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :first_name
      f.input :last_name
    end
    f.inputs 'Roles' do
      f.has_many :admin_user_roles, heading: true,
                              remove_record: true do |a|
        a.input :admin_user_id, :input_html => { :value => f.object.id }, as: :hidden
        a.input :role
      end
    end
    f.actions
  end
end
