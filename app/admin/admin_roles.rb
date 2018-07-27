ActiveAdmin.register Admin::Role, as: 'Role' do
  permit_params :name, :is_admin, permission_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :is_admin
  end

  filter :is_admin
  filter :name

  show do |role|
    attributes_table do
      row :name
      row :is_admin
      row(:permissions) do |r|
        r.permissions.map do |p|
          div p.name
        end
        nil
      end
    end
  end
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

  form do |f|
    f.inputs do
      f.input :name
      f.input :is_admin
      f.input :permission_ids, as: :selected_list, label: 'Permissions'
    end
    f.actions
  end
end
