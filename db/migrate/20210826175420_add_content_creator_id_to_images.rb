class AddContentCreatorIdToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :content_creator_id, :integer
    add_index :images, :content_creator_id
  end
end
