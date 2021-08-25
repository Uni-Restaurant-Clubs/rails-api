ActiveAdmin.register Photographer do
  actions :all, :except => [:destroy]
  permit_params do
    [:first_name, :last_name, :university_id, :email, :phone,
     :blog_url, :facebook_url, :instagram_url, :website_url,
     :biography, :signed_nda, :signed_agreement,
     :drive_folder_url,
      image_attributes: [
        :id, :photo, :image_type
      ]]
  end

  index do
    selectable_column
    id_column
      column :first_name
      column :last_name
      column :university
      column :profile_image do |photographer|
        if photographer.image
          image_tag url_for(photographer.image.resize_to_fit(75))
        end
      end
      column :email
      column :phone
      column :blog_url
      column :facebook_url
      column :instagram_url
      column :website_url
      column :drive_folder_url
    actions
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
      row :drive_folder_url
      row (:biography) { |photographer| raw(photographer.biography) }
      row :profile_image do |photographer|
        if photographer.image
          image_tag url_for(photographer.image.resize_to_fit(400))
        end
      end
      row :signed_nda do |photographer|
        if photographer.signed_nda&.url
          link_to "Signed NDA", photographer.signed_nda.url, target: "_blank"
        end
      end
      row :signed_agreement do |photographer|
        if photographer.signed_agreement&.url
          link_to "Signed Agreement", photographer.signed_agreement.url, target: "_blank"
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
      f.input :drive_folder_url
      f.input :biography, as: :quill_editor
      f.input :signed_nda, as: :file
      f.input :signed_agreement, as: :file
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
