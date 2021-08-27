ActiveAdmin.register LocationCode do
  actions :all, :except => [:destroy]
  permit_params do
    [:code, :state, :description]
  end

end
