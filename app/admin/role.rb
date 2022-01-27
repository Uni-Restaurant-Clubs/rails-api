ActiveAdmin.register Role do
  actions :all, :except => [:destroy]
  permit_params do
    [:name, :description,
      admin_user_roles_attributes: [:id, :admin_user_id, :role_id]]
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
