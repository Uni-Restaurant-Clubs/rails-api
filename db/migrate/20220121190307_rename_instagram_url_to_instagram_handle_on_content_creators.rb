class RenameInstagramUrlToInstagramHandleOnContentCreators < ActiveRecord::Migration[6.1]
  def change
    rename_column :content_creators, :instagram_url, :instagram_handle
  end
end
