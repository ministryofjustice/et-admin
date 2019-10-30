ActiveAdmin.register UploadedFile, as: 'UploadedFiles' do
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
  permit_params :file, :filename

  preserve_default_filters!
  remove_filter :file_attachment, :file_blob, :checksum

  show do
    attributes_table title: 'File Details' do
      row(:filename) { |f| link_to(f.filename, rails_blob_path(f.file, disposition: 'attachment')) }
      row :created_at
      row :updated_at
    end
  end

  index do
    selectable_column
    id_column
    column :filename
    column :created_at
    column :content_type
  end

  form do |f|
    f.inputs do
      f.input :filename
      f.input :file, as: :file
    end
    f.actions

  end

  action_item :export_ccd_multiple_workaround, only: :show, if: ->() { authorized? :export_ccd_multiples, :uploaded_file } do
    options = {
      :class         => "active-admin-export-multiples-uploaded-file",
      "data-action"  => 'export',
      "data-confirm" => 'Please confirm that the csv file should be exported to CCD multiples',
      "data-inputs"  => { case_type_id: ExternalSystem.ccd_only.all.map {|e| [e.name, e.config[:multiples_case_type_id]]} }.to_json
    }
    link_to 'Export Multiples Workaround', export_ccd_multiples_admin_uploaded_file_path, options

  end

  member_action :export_ccd_multiples, method: :post do
    if authorized? :export_ccd_multiples, :uploaded_file
      Sidekiq::Client.new(Sidekiq.redis_pool).push('class' => '::EtExporter::ExportMultiplesWorkaroundWorker', 'args' => [resource.file.service_url, params[:case_type_id]], 'queue' => 'external_system_ccd', 'retry' => false)
      redirect_to admin_uploaded_file_path, notice: 'The file has been queued for export - please verify manually'
    end
  end
end
