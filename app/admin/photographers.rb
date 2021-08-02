ActiveAdmin.register Photographer do
  actions :all, :except => [:destroy]
  permit_params do
    [:first_name, :last_name, :university_id, :email, :phone,
     :blog_url, :facebook_url, :instagram_url, :website_url,
     :biography,
     :drive_folder_url,
      image_attributes: [
        :id, :photo, :image_type
      ]]
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :university
      row :email
      row :phone
      row :blog_url
      row :facebook_url
      row :instagram_url
      row :website_url
      row (:biography) { |photographer| raw(photographer.biography) }
      row :profile_image do |photographer|
        if photographer.image
          image_tag url_for(photographer.image.resize_to_fit(400))
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :first_name
      f.input :last_name
      f.input :university
      f.input :email
      f.input :phone
      f.input :blog_url
      f.input :facebook_url
      f.input :instagram_url
      f.input :website_url
      f.input :biography, as: :quill_editor
    end
    f.inputs 'Image' do
      f.has_many :image, heading: false,
                              remove_record: true do |a|
        a.input :image_type, :input_html => { :value => "profile" }, as: :hidden
        a.input :photo, as: :file
      end
    end
    f.actions
  end


end
