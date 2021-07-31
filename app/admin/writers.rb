ActiveAdmin.register Writer do
  permit_params = [:first_name, :last_name, :university_id, :email, :phone,
                   :drive_folder_url]

end
