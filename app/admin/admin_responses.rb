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
      response.uploaded_files.et3_user_files.map do |f|
        if f.file.attached?
          link_to("<span class='claim-file-icon #{f.filename.split('.').last}'></span>".html_safe, rails_blob_path(f.file, disposition: 'attachment'))
        else
          "<span class='claim-file-icon problem'></span>".html_safe
        end
      end.join('').html_safe
    end
    column :created_at

    actions do |response|
      options = {
        method: :post,
        remote:true,
        class: "member_link",
        "data-action": 'repair',
        "data-confirm": 'This action may generate duplicates if the response does not need repairing. Are you sure ?'
      }
      item "Repair", repair_admin_response_path(response.id), options if authorized?(:repair, :response)
    end
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

    panel('Events') do
      table_for response.events.order(id: :asc) do
        column(:id) { |r| auto_link r, r.id }
        column(:created_at)
        column(:name)
        column(:data)
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

  filter :reference_cont, label: 'Reference'
  filter :case_number
  filter :created_at
  filter :respondent_name_cont, label: 'Respondent Name'
  filter :representative_name_cont, label: 'Representative Name'
  filter :office
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

  member_action :repair, method: :post, respond_to: :js do
    if Admin::RepairResponseService.call(params[:id].to_i).valid?
      render js: "ActiveAdmin.ModalDialog('Response submitted for repair - it should be exported within 30 minutes', [], function() {});"
    else
      render js: "ActiveAdmin.ModalDialog('Response failed to repair', [], function() {});"
    end
  end

end
