class AddCodeToContentCreators < ActiveRecord::Migration[6.1]
  def change
    add_column :content_creators, :location_code_id, :integer
    add_index :content_creators, :location_code_id
  end
end
