ActiveAdmin.register AcasCertificateForm, as: 'Acas Certificates' do
  menu false

  show do
    div class: 'active-admin-acas search-results-search' do
      active_admin_form_for('', url: admin_acas_certificate_url(id: 'search'), method: :get) do |f|
        f.inputs 'ACAS Search' do
          f.input :number, label: 'Please enter your ACAS Early Conciliation Certificate number', input_html: { value: params[:number] }
        end
        f.actions do
          f.action :submit, label: 'Search'
        end
      end
    end

    unless acas_certificates.certificate.nil_instance?
      div class: 'search-results' do
        attributes_table title: 'Respondent' do
          row :date_of_receipt
          row :date_of_issue
          row('Difference') do |r|
            if r.date_of_issue.present? && r.date_of_receipt.present?
              "#{(r.date_of_issue.to_date - r.date_of_receipt.to_date).to_i} days"
            else
              'NA'
            end
          end
          row :method_of_issue
          row :respondent_name
        end
        attributes_table title: 'Lead Claimant' do
          row :claimant_name
        end
        div class: 'acas-certificate' do
          attributes_table title: 'Certificate' do
            row(:certificate_download) { |r| a(download: "#{r.respondent_name} - #{r.claimant_name}.pdf", type: 'application/pdf', href: "data:application/pdf;base64,#{r.certificate.certificate_base64}") { 'Download' } }
            row(:certificate_preview) { |r| iframe src: "data:application/pdf;base64,#{r.certificate.certificate_base64}" }
          end
        end
      end
    end

    if acas_certificates.errors.present?
      div class: 'flash' do
        div class: 'search-errors flash_error' do
          acas_certificates.errors.messages[:number].each do |message|
            span class: 'error' do
              message
            end
          end
        end
      end
    end


  end
  controller do
    def find_resource
      form = ::AcasCertificateForm.new(number: params[:number], current_admin_user: current_admin_user)
      ::Admin::AcasCertificateSearchService.call(form)
      form
    end
  end
end
