class RenameBlogUrlToLinkedinUrl < ActiveRecord::Migration[6.1]
  def change
    rename_column :content_creators, :blog_url, :linkedin_url
    add_column :content_creators, :youtube_url, :string
  end
end
