ActiveAdmin.register DefaultOfficeClaim, as: 'Default Office Claims' do
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

  preserve_default_filters!
  remove_filter :claim_claimants, :claim_respondents, :claim_representatives, :claim_uploaded_files
  remove_filter :secondary_claimants, :secondary_respondents, :secondary_representatives
  remove_filter :uploaded_files, :primary_representative, :submission_channel, :jurisdiction
  remove_filter :administrator, :created_at, :updated_at, :other_known_claimant_names
  remove_filter :discrimination_claims, :pay_claims, :desired_outcomes, :other_claim_details
  remove_filter :claim_details, :other_outcome, :send_claim_to_whistleblowing_entity
  remove_filter :miscellaneous_information, :is_unfair_dismissal, :primary_claimant, :primary_respondent
  remove_filter :exports, :commands, :events, :pdf_template_reference, :email_template_reference
  remove_filter :confirmation_email_recipients, :time_zone, :office, :case_type
  filter :primary_claimant_first_name_cont, label: "Primary claimant first name"
  filter :primary_claimant_last_name_cont, label: "Primary claimant last name"
  filter :primary_respondent_name_or_primary_respondent_contact_cont, label: 'Primary Respondent Name'
  filter :case_type_equals, as: :select, label: 'Case Type', collection: [ 'Single', 'Multiple' ]
  includes :secondary_claimants, :primary_claimant, :secondary_respondents, :primary_respondent, :exports, :office, uploaded_files: [:file_blob], exports: [:external_system, :events]

  index do
    selectable_column
    column :claimant_name do |c|
      c.name
    end
    column :respondent_name do |c|
      c.primary_respondent.name
    end
    column :reference
    column :office
    column :date_of_receipt
    column :case_type
    column :claimant_count
    column :files do |c|
      c.uploaded_files.select {|u| u.filename =~ /\.pdf|\.csv|\.rtf/}.map do |f|
        if f.file.attached?
          link_to("<span class='claim-file-icon #{f.filename.split('.').last}'></span>".html_safe, rails_blob_path(f.file, disposition: 'attachment'))
        else
          "<span class='claim-file-icon problem'></span>".html_safe
        end
      end.join('').html_safe
    end
    column :ccd_state do |c|
      export = c.exports.detect { |e| e.external_system.reference.include?('ccd') }
      next '' if export.nil?
      str = export.state
      count = c.claimant_count
      if str == 'in_progress' && count > 1
        so_far = export.events.sub_case_exported.count
        str = "#{str} (#{so_far}/#{count})"
        next "<a href='#{admin_export_url(export.id)}'>#{str}</a>".html_safe
      end
      if ['failed', 'erroring'].include? str
        next "<a href='#{admin_export_url(export.id)}'>#{str}</a>".html_safe
      end
      next str unless str == 'complete'
      str = "#{str} (#{count})" if count > 1
      "<a href='#{admin_export_url(export.id)}'>#{str}</a> (<a target='_blank' href='#{ENV.fetch('CCD_UI_BASE_URL', '')}/#{export.external_data['case_type_id']}/#{export.external_data['case_id']}'>#{export.external_system.name} - #{export.external_data['case_reference']}</a>)".html_safe
    end
    actions do |claim|
      options = {
        class: "member_link",
        remote: true,
        data: {
          action: :assign,
          confirm: 'This action will transfer this claim to the selected office - are you sure?',
          inputs: {office: Office.order(name: :asc).excluding_default.pluck(:name, :id)}.to_json,
          claim_id: claim.id
        }
      }
      item "Assign", assign_admin_default_office_claim_path(claim.id), options if authorized?(:assign, :default_office_claim)
    end
  end

  form do |f|
    f.inputs do
      f.input :reference
      f.input :submission_reference
      f.input :submission_channel
      f.input :primary_claimant, member_label: Proc.new { |c| "#{c.first_name} #{c.last_name}" }
      f.input :secondary_claimant_ids, as: :selected_list, label: 'Claimants'
    end
    f.actions
  end

  show do |claim|
    default_attribute_table_rows = active_admin_config.resource_columns
    attributes_table(*default_attribute_table_rows)
    panel('Files') do
      table_for claim.uploaded_files do
        column(:id) { |r| auto_link r, r.id }
        column(:filename) { |f| link_to(f.filename, rails_blob_path(f.file, disposition: 'attachment')) if f.file.attached? }
      end
    end
    panel('Secondary Claimants') do
      table_for claim.secondary_claimants do
        column(:id) { |r| auto_link r, r.id }
        column :title
        column :first_name
        column :last_name
      end
    end

    panel('Secondary Respondents') do
      table_for claim.secondary_respondents do
        column(:id) { |r| auto_link r, r.id }
        column :name
      end
    end

    panel('Secondary Representatives') do
      table_for claim.secondary_representatives do
        column(:id) { |r| auto_link r, r.id }
        column(:name)
      end
    end

    panel('Events') do
      table_for claim.events.order(id: :asc) do
        column(:id) { |r| auto_link r, r.id }
        column(:created_at)
        column(:name)
        column(:data)
      end
    end

    panel('Commands') do
      table_for claim.commands do
        column(:id) { |r| auto_link r, r.id }
      end
    end

    active_admin_comments
  end

  scope :all, default: true
  scope :not_exported
  scope :not_exported_to_ccd

  batch_action :export,
               form: -> { {external_system_id: ExternalSystem.pluck(:name, :id)} },
               if: ->(_user) { authorized? :create, :export } do |ids, inputs|
    response = Admin::ExportClaimsService.call(ids.map(&:to_i), inputs['external_system_id'].to_i)
    if response.errors.present?
      redirect_to admin_claims_path, alert: "An error occured exporting your claims - #{response.errors.full_messages.join('<br/>')}"
    else
      redirect_to admin_claims_path, notice: 'Claims queued for export'
    end
  end

  action_item :assign,
              only: :show,
              if: ->() { authorized? :assign, :default_office_claim } do
    options = {
      class: "member_link",
      remote: true,
      data: {
        action: :assign,
        confirm: 'This action will transfer this claim to the selected office - are you sure?',
        inputs: {office: Office.order(name: :asc).excluding_default.pluck(:name, :id)}.to_json,
        claim_id: resource.id,
        success_path: admin_default_office_claims_path
      }
    }
    link_to 'Assign to office', assign_admin_default_office_claim_path(resource.id), options
  end

  member_action :assign, method: :post, respond_to: :js do
    if Admin::AssignClaimService.call(claim_id: params[:id].to_i, office_id: params[:office_id].to_i, user_id: current_admin_user.id).valid?
      alert_msg = 'The claim has been assigned to the office'
      if params[:success_path].present?
        redirect_to params[:success_path], path_only: true, alert: alert_msg
      else
        redirect_back alert: alert_msg, fallback_location: admin_default_office_claims_path
      end
    else
      redirect_back flash: {error: 'There was an issue assigning the claim to the office.  Please contact support'}, fallback_location: admin_default_office_claims_path
    end
  end
end
