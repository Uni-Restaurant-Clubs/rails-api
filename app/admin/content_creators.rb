ActiveAdmin.register ContentCreator do
  actions :all, :except => [:destroy]
  permit_params do
    [:first_name, :last_name, :university_id, :email, :phone,
     :linkedin_url, :facebook_url, :instagram_url, :website_url,
     :bio, :signed_nda, :signed_agreement, :location_code_id,
     :drive_folder_url, :public_unique_username, :creator_type,
     :youtube_url,
      image_attributes: [
        :id, :photo, :image_type
      ]]
  end

  scope :all, default: true
  scope :writers do |content_creators|
    content_creators.writers
  end
  scope :photographers do |content_creators|
    content_creators.photographers
  end

  index do
    selectable_column
    id_column
      column :creator_type
      column :location_code
      column :public_unique_username
      column :first_name
      column :last_name
      column :profile_image do |photographer|
        if photographer.image
          image_tag url_for(photographer.image.resize_to_fit(75))
        end
      end
      column :email
      column :phone
    actions
  end

  show do
    attributes_table do
      row :creator_type
      row :location_code
      row :public_unique_username
      row :first_name
      row :last_name
      row :university
      row :email
      row :phone
      row :linkedin_url
      row :youtube_url
      row :facebook_url
      row :instagram_url
      row :website_url
      row :drive_folder_url
      row (:bio) { |photographer| raw(photographer.bio) }
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
      f.input :creator_type
      f.input :location_code
      f.input :public_unique_username
      f.input :first_name
      f.input :last_name
      f.input :university
      f.input :email
      f.input :phone
      f.input :linkedin_url
      f.input :youtube_url
      f.input :facebook_url
      f.input :instagram_url
      f.input :website_url
      f.input :drive_folder_url
      f.input :bio, as: :quill_editor
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
