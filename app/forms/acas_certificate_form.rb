class AcasCertificateForm
  include ActiveModel::Model
  attr_accessor :number, :certificate, :current_admin_user
  delegate :date_of_receipt, :date_of_issue, :method_of_issue, :respondent_name, :claimant_name, to: :certificate
end
