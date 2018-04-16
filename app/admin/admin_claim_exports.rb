ActiveAdmin.register Admin::ClaimExport, as: 'ClaimExports' do
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
  show do |claim_export|
    attributes_table do
      row(:claim) do
        div auto_link claim_export.claim.name, claim_export.claim_id
      end
      row(:pdf_file) do
        div claim_export.pdf_file.filename unless claim_export.pdf_file_id.nil?
      end
      row :in_progress
      row(:messages) do
        claim_export.messages.map do |message|
          div message
        end
      end
      row :created_at
      row :updated_at
    end
  end
end
