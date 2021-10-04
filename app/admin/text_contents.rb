ActiveAdmin.register TextContent do
  actions :all, :except => [:destroy]

  permit_params do
    [:text, :category, :name]
  end

  index do
    selectable_column
    id_column
    column :name
    column :category
    actions
  end

  show do
    attributes_table do
      row :name
      row :category
      row (:text) { |content| raw(content.text) }
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :name
      f.input :category
      f.input :text, as: :quill_editor
    end
    f.actions
  end

end
