Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :jadu do
    post 'new-claim' => 'claims#create'
  end
end
