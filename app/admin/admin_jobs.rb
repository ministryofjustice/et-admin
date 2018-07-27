ActiveAdmin.register_page 'Jobs' do
  content do
    div class: 'active-admin-sidekiq' do
      iframe src: '/admin/sidekiq'
    end
  end
end