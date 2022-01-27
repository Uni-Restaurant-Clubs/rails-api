ActiveAdmin.register Role do
  permit_params do
    [:name, :description]
  end

end
