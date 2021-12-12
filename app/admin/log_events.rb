ActiveAdmin.register LogEvent do
  actions :all, :except => [:destroy, :update]
end
