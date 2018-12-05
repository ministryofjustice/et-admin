ActiveAdmin.register AtosFile, as: 'AtosFiles' do
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

  sidebar :systems do
    obj = OpenStruct.new(external_system_reference: assigns[:external_system].reference)
    form_for obj, as: '', url: admin_atos_files_path, method: :get do |f|
      f.collection_radio_buttons :external_system_reference, ExternalSystem.where("reference ilike '%atos%'"), :reference, :name
      f.submit value: 'Go To System', data: { disable_with: 'Go To System' }
    end
  end

  index do
    column(:id, sortable: false) do |r|
      link_to "Download #{r.id}", download_admin_atos_file_path(id: URI.encode(r.id).gsub(/\./, '%2E'), external_system_reference: r.external_system.reference)
    end
  end

  member_action :download, method: :get do
    tmp_file = Tempfile.new
    tmp_file.binmode
    resource.download to: tmp_file
    tmp_file.rewind
    send_file tmp_file, filename: resource.id
  end

  controller do
    before_action do
      ref = params.fetch(:external_system_reference, 'atos')
      @external_system = ExternalSystem.find_by(reference: ref)
      render(status: 404, inline: "External system not found") unless @external_system
    end

    def find_resource
      ::AtosFile.find(URI.decode(params[:id]), external_system: @external_system)
    end

    def apply_decorations(resource)
      resource
    end

    def apply_sorting(collection)
      collection
    end

    def apply_filtering(collection)
      collection
    end

    def apply_scoping(collection)
      collection
    end

    def apply_includes(collection)
      collection
    end

    def apply_pagination(collection)
      collection
      collection.all(external_system: @external_system)
    end
  end
end
