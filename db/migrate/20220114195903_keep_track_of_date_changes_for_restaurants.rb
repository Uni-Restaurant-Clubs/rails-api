class KeepTrackOfDateChangesForRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :last_time_a_review_related_date_was_updated, :datetime
  end
end
