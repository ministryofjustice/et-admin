require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :'admin/users', ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  authenticate :admin_user, -> (u) { u.is_admin? || u.permission_names.include?('read_jobs') } do |u|
    mount Sidekiq::Web => '/admin/sidekiq'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

