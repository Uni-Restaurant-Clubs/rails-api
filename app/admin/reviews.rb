ActiveAdmin.register Review do
  permit_params = [
                    image_attributes: [
                      :id, :title, :image
                    ]
                  ]

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :restaurant_id
      f.input :reviewed_at
    end
    f.inputs 'Images' do
      f.has_many :images, heading: false,
                              remove_record: true do |a|
        a.input :title
        a.input :image
      end
    end
    f.actions
  end

end
