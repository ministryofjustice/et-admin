ActiveAdmin.register Claimant, as: 'Claimants' do
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
  remove_filter :address

  show do |claimant|
    attributes_table do
      row :title
      row :first_name
      row :last_name
      row(:address) do |r|
        div r.address.building
        div r.address.street
        div r.address.locality
        div r.address.county
        div r.address.post_code
      end
      row :address_telephone_number
      row :mobile_number
      row :email_address
      row :contact_preference
      row :gender
      row :date_of_birth
      row :created_at
      row :updated_at
    end

  end
end
