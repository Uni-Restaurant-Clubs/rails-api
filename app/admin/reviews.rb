ActiveAdmin.register Review do
  actions :all, :except => [:destroy]

  permit_params do
    permitted = [
                  :restaurant_id, :university_id, :writer_id, :photographer_id,
                  :reviewed_at,
                  images_attributes: [
                    :id, :title, :photo, :featured
                  ]
                ]
    permitted
  end

  index do
    selectable_column
    id_column
    column :restaurant
    column :university
    column :writer
    column :photographer
    column :reviewed_at
    column :featured_image do |review|
      if review.images.featured.any?
        image_tag url_for(review.images.featured.first.thumb)
      end
    end
    actions
  end

  show do
    attributes_table do
      row :restaurant
      row :university
      row :writer
      row :photographer
      row :reviewed_at
      table_for review.images do
        column "Title" do |image|
          image.title
        end
        column "Featured" do |image|
          image.featured
        end
        column "Image" do |image|
          image.title
          image_tag url_for(image.large)
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :restaurant
      f.input :writer
      f.input :photographer
      f.input :university
      f.input :reviewed_at, as: :date_time_picker
    end
    f.inputs 'Image' do
      f.has_many :images, heading: false,
                              remove_record: true do |a|
        a.input :title
        a.input :featured
        a.input :photo, as: :file
      end
    end
    f.actions
  end

end
