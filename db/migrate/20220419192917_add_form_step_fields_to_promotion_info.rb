class AddFormStepFieldsToPromotionInfo < ActiveRecord::Migration[6.1]
  def change
    add_column :promotion_infos, :form_step_one_completed_at, :datetime
  end
end
