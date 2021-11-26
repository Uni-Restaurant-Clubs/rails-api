class AddPhotographerFieldsToContentCreators < ActiveRecord::Migration[6.1]
  def change
    add_column :content_creators, :food_preferences, :text
    add_column :content_creators, :camera_equipment_description, :text
    add_column :content_creators, :editing_software, :string
    add_column :content_creators, :notes, :text
    add_column :content_creators, :allergies, :string
  end
end
