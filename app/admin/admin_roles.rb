ActiveAdmin.register Admin::Role, as: 'Roles' do
  permit_params :name, :is_admin

  index do
    selectable_column
    id_column
    column :name
    column :is_admin
  end

  filter :is_admin
  filter :name
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

end
