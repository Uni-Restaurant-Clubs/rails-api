ActiveAdmin.register Address do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :geocoded_address, :instructions, :apt_suite_number, :street_number, :street_name, :street_type, :city, :state, :country, :zipcode, :latitude, :longitude
  #
  # or
  #
  # permit_params do
  #   permitted = [:geocoded_address, :instructions, :apt_suite_number, :street_number, :street_name, :street_type, :city, :state, :country, :zipcode, :latitude, :longitude]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  belongs_to :restaurant
end
