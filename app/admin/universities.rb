ActiveAdmin.register University do
  actions :all, :except => [:destroy]
  permit_params do
    [:name, :school_type]
  end

end
