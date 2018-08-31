ActiveAdmin.register OfficePostCode, as: 'Office Post Codes' do
  actions :all
  config.batch_actions = false

  includes :office

  permit_params :postcode, :office_id

  filter :office
  filter :postcode

  index do
    column :postcode
    column :office
    actions
  end
end
