class AddFeaturePeriodIdToLogEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :log_events, :feature_period_id, :integer
    add_index :log_events, :feature_period_id
  end
end
