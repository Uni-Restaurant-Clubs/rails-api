class AddApplicationColumnsToContentCreators < ActiveRecord::Migration[6.1]
  def change
    add_column :content_creators, :is_writer, :boolean, default: false
    add_column :content_creators, :is_photographer, :boolean, default: false
    add_column :content_creators, :is_videographer, :boolean, default: false
    add_column :content_creators, :intro_application_text, :text
    add_column :content_creators, :experiences_application_text, :text
    add_column :content_creators, :why_join_application_text, :text
    add_column :content_creators, :application_social_media_links, :text
    add_column :content_creators, :status, :integer
    add_index :content_creators, :status
    add_index :content_creators, :is_writer
    add_index :content_creators, :is_photographer
    add_index :content_creators, :is_videographer
  end
end
