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

  preserve_default_filters!
  remove_filter :pdf_file, :resource_type, :in_progress, :messages, :events

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

    panel('Events') do
      table_for export.events do
        column :created_at
        column :state
        column :uuid
        column :data
        column :percent_complete
        column :message
      end
    end

  end
end
