ActiveAdmin.register Review do
  actions :all, :except => [:destroy]
  permit_params do
    permitted = [
                  image_attributes: [
                    :id, :title, :image
                  ]
                ]
    permitted
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :restaurant
      f.input :writer
      f.input :photographer
      f.input :university
      f.input :reviewed_at
    end
    f.inputs 'Image' do
      f.has_many :images, heading: false,
                              remove_record: true do |a|
        a.input :title
        a.input :photo
      end
    end
    f.actions
  end

end
