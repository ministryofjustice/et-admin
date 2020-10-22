ActiveAdmin.register Response, as: 'Responses' do
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

  index download_links: true do
    selectable_column
    column :reference
    column 'Respondent Name', :respondent_id do |r|
      r.respondent.name
    end
    column :case_number
    column :claimants_name
    column :files do |response|
      response.uploaded_files.select { |u| u.filename =~ /\.pdf|\.csv|\.rtf/ }.map do |f|
        if f.file.attached?
          link_to("<span class='claim-file-icon #{f.filename.split('.').last}'></span>".html_safe, rails_blob_path(f.file, disposition: 'attachment'))
        else
          "<span class='claim-file-icon problem'></span>".html_safe
        end
      end.join('').html_safe
    end
    column :created_at

    actions
  end

  show do |response|
    default_attribute_table_rows = active_admin_config.resource_columns
    attributes_table(*default_attribute_table_rows)

    panel('Files') do
      table_for response.uploaded_files do
        column(:id) { |r| auto_link r, r.id }
        column(:filename)
      end
    end

    panel('Commands') do
      table_for response.commands do
        column(:id) { |r| auto_link r, r.id }
      end
    end

    active_admin_comments
  end

  preserve_default_filters!
  remove_filter :respondent, :representative, :response_uploaded_files, :uploaded_files, :exports, :commands
  remove_filter :agree_with_early_conciliation_details, :disagree_conciliation_reason, :agree_with_employment_dates
  remove_filter :employment_start, :employment_end, :disagree_employment, :continued_employment
  remove_filter :agree_with_claimants_description_of_job_or_title, :disagree_claimants_job_or_title
  remove_filter :agree_with_claimants_hours, :queried_hours, :agree_with_earnings_details
  remove_filter :queried_pay_before_tax, :queried_pay_before_tax_period
  remove_filter :queried_take_home_pay, :queried_take_home_pay_period
  remove_filter :agree_with_claimant_notice, :disagree_claimant_notice_reason
  remove_filter :agree_with_claimant_pension_benefits, :disagree_claimant_pension_benefits_reason
  remove_filter :defend_claim, :defend_claim_facts, :updated_at, :pdf_template_reference, :email_template_reference

  filter :reference
  filter :case_number
  filter :created_at
  filter :respondent_name_cont, label: 'Respondent Name'
  filter :representative_name_cont, label: 'Representative Name'
  filter :reference_starts_with, label: 'Office', as: :select, collection: proc { Office.all.map {|office| [office.name, number_with_precision(office.code, significant: true, precision: 2)]} }
  scope :all, default: true
  scope :not_exported
  scope :not_exported_to_ccd

  batch_action :export, form: -> { { external_system_id: ExternalSystem.pluck(:name, :id) } },
               if:            ->(_user) { authorized? :create, :export } do |ids, inputs|
    response = Admin::ExportResponsesService.call(ids.map(&:to_i), inputs['external_system_id'].to_i)
    if response.errors.present?
      redirect_to admin_claims_path, alert: "An error occured exporting your responses - #{response.errors.full_messages.join('<br/>')}"
    else
      redirect_to admin_responses_path, notice: 'Responses queued for export'
    end
  end

end
