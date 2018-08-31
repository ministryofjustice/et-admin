ActiveAdmin.register Export, as: 'Exports' do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  show do |export|
    attributes_table do
      row(:resource) do
        div auto_link export.resource.name, export.resource_id
      end
      row :in_progress
      row(:messages) do
        export.messages.map do |message|
          div message
        end
      end
      row :created_at
      row :updated_at
    end
  end
end
