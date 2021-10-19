class AddApplicationColumnsToContentCreators < ActiveRecord::Migration[6.1]
  def change
    add_column :content_creators, :roles, :string, array: true, default: []
    add_column :content_creators, :status, :integer
    add_index :content_creators, :status
    add_index :content_creators, :roles, using: 'gin'
  end
end
