ActiveAdmin.register ContentCreator do
  actions :all, :except => [:destroy]
  permit_params do
    [:first_name, :last_name, :university_id, :email, :phone,
     :linkedin_url, :facebook_url, :instagram_url, :website_url,
     :bio, :signed_agreement, :location_code_id,
     :drive_folder_url, :public_unique_username,
     :youtube_url, :is_writer, :is_photographer, :is_videographer,
     :intro_application_text, :experiences_application_text,
     :why_join_application_text, :application_social_media_links, :resume,
     :writing_example, :status, :intro_video,
      image_attributes: [
        :id, :photo, :image_type
      ]]
  end

  scope :all, default: true
  scope :active_writers do |content_creators|
    content_creators.active.writers
  end
  scope :active_photographers do |content_creators|
    content_creators.active.photographers
  end
  scope :active_videographers do |content_creators|
    content_creators.active.videographers
  end
  scope :all_active do |content_creators|
    content_creators.active
  end
  scope :newly_applied do |content_creators|
    content_creators.applied
  end
  scope :accepted do |content_creators|
    content_creators.accepted
  end
  scope :denied do |content_creators|
    content_creators.denied
  end
  scope :archived do |content_creators|
    content_creators.archived
  end
  scope :suspended do |content_creators|
    content_creators.suspended
  end
  scope :inactive do |content_creators|
    content_creators.inactive
  end

  index do
    selectable_column
    id_column
      column :status
      column :is_writer
      column :is_photographer
      column :is_videographer
      column :location_code
      column :first_name
      column :last_name
      column :profile_image do |photographer|
        if photographer.image
          image_tag url_for(photographer.image.resize_to_fit(75))
        end
      end
    actions
  end

  show do
    attributes_table do
      row :status
      row :is_writer
      row :is_photographer
      row :is_videographer
      row :intro_application_text
      row :experiences_application_text
      row :why_join_application_text
      row :application_social_media_links
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
      row :intro_video do |photographer|
        if photographer.intro_video&.url
          link_to "intro Video", photographer.intro_video.url, target: "_blank"
        end
      end
      row :profile_image do |photographer|
        if photographer.image
          image_tag url_for(photographer.image.resize_to_fit(400))
        end
      end
      row :signed_agreement do |photographer|
        if photographer.signed_agreement&.url
          link_to "Signed Agreement", photographer.signed_agreement.url, target: "_blank"
        end
      end
      row :resume do |creator|
        if creator.resume&.url
          link_to "resume", creator.resume.url, target: "_blank"
        end
      end
      row :writing_example do |creator|
        if creator.writing_example&.url
          link_to "writing example", creator.writing_example.url, target: "_blank"
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :status
      f.input :is_writer
      f.input :is_photographer
      f.input :is_videographer
      f.input :intro_application_text
      f.input :experiences_application_text
      f.input :why_join_application_text
      f.input :application_social_media_links
      f.input :resume, as: :file
      f.input :writing_example, as: :file
      f.input :intro_video, as: :file
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
