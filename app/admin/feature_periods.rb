ActiveAdmin.register FeaturePeriod do
  actions :all, :except => [:destroy]
  permit_params do
    permitted = [
      :discount_type, :discount_number, :status, :start_date, :end_date,
      :disclaimers, :perks, :notes, :restaurant_id
    ]
    #permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
end
