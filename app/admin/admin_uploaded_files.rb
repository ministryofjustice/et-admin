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
  show do
    attributes_table title: 'File Details' do
      row(:filename) { |f| link_to(f.filename, rails_blob_path(f.file, disposition: 'attachment')) }
      row :created_at
      row :updated_at
    end
  end

end
