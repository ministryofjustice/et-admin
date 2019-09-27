ActiveAdmin.register ExternalSystem, as: 'External Systems' do
  includes :configurations
  filter :name
  filter :reference

  permit_params :name, :reference, :enabled, :export_claims, :export_responses, :export_queue, office_codes: [], configurations_attributes: [:id, :key, :value, :_destroy]

  show do |system|
    default_attribute_table_rows = active_admin_config.resource_columns
    attributes_table(*default_attribute_table_rows)
    attributes_table title: "Configuration" do
      system.configurations.each do |config|
        row config.key do
          config.key == 'password' ? '*******' : config.value
        end
      end

    end
    active_admin_comments
  end

  index download_links: true do
    id_column
    column :name
    column :reference
    column :office_codes
    column :enabled
    column :export_claims
    column :export_responses
    actions
  end

  form title: 'System Details' do |f|
    f.semantic_errors
    f.inputs 'Details' do
      input :name
      input :reference
      input :enabled
      input :export_claims
      input :export_responses
      input :export_queue
      input :office_codes, as: :check_boxes, collection: Office.all.map {|o| [o.name, o.code]}
    end

    f.inputs do
      f.has_many :configurations, allow_destroy: true do |a|
        a.input :key
        a.input :value
      end
    end
    f.actions
  end

end
