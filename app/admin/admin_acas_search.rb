ActiveAdmin.register_page 'Certificate Search' do
  menu parent: 'Acas'
  content do
    div class: 'active-admin-acas search-start' do
      active_admin_form_for('', url: admin_acas_certificate_url(id: 'search'), method: :get) do |f|
        f.inputs 'ACAS Search' do
          f.input :number, label: 'Please enter your ACAS Early Conciliation Certificate number'
        end
        f.actions do
          f.action :submit, label: 'Search'
        end
      end
    end
  end
end
