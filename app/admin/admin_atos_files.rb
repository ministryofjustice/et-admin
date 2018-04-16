ActiveAdmin.register Admin::AtosFile, as: 'AtosFiles' do
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

  index do
    column(:id, sortable: false) do |r|
      link_to "Download #{r.id}", download_admin_atos_file_path(id: URI.encode(r.id).gsub(/\./, '%2E'))
    end
  end

  member_action :download, method: :get do
    tmp_file = Tempfile.new
    tmp_file.binmode
    resource.download to: tmp_file
    send_file tmp_file, filename: resource.id
  end

  controller do
    def find_resource
      ::Admin::AtosFile.find(URI.decode(params[:id]))
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
      collection.all
    end
  end
end
