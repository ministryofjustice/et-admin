ActiveAdmin.register Claim, as: 'Claims' do
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
  remove_filter :miscellaneous_information, :is_unfair_dismissal, :primary_claimant, :primary_respondent, :primary_representative
  filter :primary_claimant_first_name_cont, label: "Primary claimant first name"
  filter :primary_claimant_last_name_cont, label: "Primary claimant last name"
  filter :primary_respondent_name_or_primary_respondent_contact_cont, label: 'Primary Respondent Name'

  config.batch_actions = true

  config.scoped_collection_actions_if = -> do
    next false unless authorized?(:re_export, resource_class)
    filtered_scoped = (params[:q] || params[:scope])
    on_all = active_admin_config.scoped_collection_actions_on_all
    has_actions = active_admin_config.scoped_collection_actions.any?
    batch_actions_enabled = active_admin_config.batch_actions_enabled?
    ( batch_actions_enabled && has_actions && (filtered_scoped || on_all) )
  end

  scoped_collection_action :re_export do
    unless authorized?(:re_export, resource_class)
      flash[:error] = "You do not have permissions to re export"
      head :ok and next
    end
    Rails.logger.info "Collection action will be performed on #{scoped_collection_records.map(&:id)}"
  end

  index do
    selectable_column
    id_column
    column :name
    column :reference
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

    panel('Files') do
      table_for claim.uploaded_files do
        column(:id) { |r| auto_link r, r.id }
        column(:filename)
      end
    end
    active_admin_comments
  end

end
