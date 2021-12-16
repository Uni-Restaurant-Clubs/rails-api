ActiveAdmin.register Review do

  controller do
    def find_collection(options = {})
      super.unscoped.page(params[:page]).per(10)
    end

    def resource
      Review.unscoped { super }
    end

  end

  actions :all, :except => [:destroy, :new, :create]

  permit_params do
    permitted = [
                  :restaurant_id, :university_id, :writer_id, :photographer_id,
                  :reviewed_at, :full_article, :medium_article, :small_article,
                  :article_title, :status,
                  images_attributes: [
                    :id, :title, :photo, :featured, :image_type
                  ]
                ]
    permitted
  end

  index do
    selectable_column
    id_column
    column :restaurant
    column :status
    column :university
    column :writer
    column :photographer
    column :reviewed_at
    column :featured_image do |review|
      if review.images.featured.any?
        image_tag url_for(review.images.featured.first.resize_to_fit(100))
      end
    end
    actions
  end

  show do
    attributes_table do
      row :restaurant
      row :status
      row :university
      row :writer
      row :photographer
      row :reviewed_at
      row :article_title
      row (:full_article) { |review| raw(review.full_article) }
      row (:medium_article) { |review| raw(review.medium_article) }
      row (:small_article) { |review| raw(review.small_article) }
      table_for review.images do
        column "Title" do |image|
          image.title
        end
        column "Featured" do |image|
          image.featured
        end
        column "Image" do |image|
          image.title
          image_tag url_for(image.resize_to_fit(800))
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :restaurant
      f.input :status
      f.input :writer
      f.input :photographer
      f.input :university
      f.input :reviewed_at, as: :date_time_picker
      f.input :article_title
      f.input :full_article, as: :quill_editor
      f.input :medium_article, as: :quill_editor
      f.input :small_article, as: :quill_editor
    end
    f.inputs 'Image' do
      f.has_many :images, heading: false,
                              remove_record: true do |a|
        a.input :title
        a.input :featured
        a.input :image_type, :input_html => { :value => "review" }, as: :hidden
        a.input :photo, as: :file, hint: a.template.image_tag(url_for(a.object.resize_to_fit(300)))

      end
    end
    f.actions
  end

end
