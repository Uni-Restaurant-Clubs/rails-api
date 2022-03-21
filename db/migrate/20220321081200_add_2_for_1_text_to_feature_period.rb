class Add2For1TextToFeaturePeriod < ActiveRecord::Migration[6.1]
  def change
    add_column :feature_periods, :two_for_one_item, :string
  end
end
