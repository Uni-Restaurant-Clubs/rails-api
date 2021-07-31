ActiveAdmin.register Photographer do
  actions :all, :except => [:destroy]
  permit_params do
    [:first_name, :last_name, :university_id, :email, :phone,
     :drive_folder_url]
  end


end
