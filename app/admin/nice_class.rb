ActiveAdmin.register NiceClass do
  permit_params :short_description, :explanatory_note

  actions :all, except: [:create, :new]
end
