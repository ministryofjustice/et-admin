ActiveAdmin.register Admin::User, as: 'User' do
  permit_params :email, :password, :password_confirmation

  collection_action :import, method: :get do
    authorize!(:import, active_admin_config.resource_class)
    @import_service = ::Admin::UsersImportService.new
    render
  end

  action_item :import, only: :index do
    if authorized?(:import, active_admin_config.resource_class)
      link_to(
        'Import Users',
        action: :import
      )
    end
  end

  collection_action :do_import, method: :post do
    authorize!(:import, active_admin_config.resource_class)
    _params = params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params
    params = ActiveSupport::HashWithIndifferentAccess.new _params
    @import_service = ::Admin::UsersImportService.new(tempfile: params.dig(:admin_users_import_service, :file).try(:tempfile))
    @import_service.call
    if @import_service.errors.empty?
      redirect_to admin_users_path
    else
      render :import
    end
  end

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :department
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  show do |user|
    attributes_table do
      row :email
      row :reset_password_sent_at
      row :remember_created_at
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :permission_names
      row :is_admin
      row :created_at
      row :updated_at
      row :username
      row :name
      row :department
      row :failed_attempts
      row :locked_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.input :department
      f.input :password
      f.input :password_confirmation
      f.input :role_ids, as: :selected_list, label: 'Roles'
    end
    f.actions
  end

end
