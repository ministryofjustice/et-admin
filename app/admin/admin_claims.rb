ActiveAdmin.register Claim, as: 'Claims' do
#   preserve_default_filters!
#   filter :claim_claimants, label: 'Secondary Claimants', collection: proc {
#     ClaimClaimant.all.map { |claim| claim.claimant.name }
#   }
#   filter :claim_respondents, collection: proc {
#     ClaimRespondent.all.map { |claim| claim.respondent.name }
#   }
#   filter :claim_representatives, collection: proc {
#     ClaimRepresentative.all.map { |claim| claim.representative.name}
#   }
#   filter :claim_uploaded_files, collection: proc {
#     ClaimUploadedFile.all.map { |claim| claim.uploaded_file.filename}
#   }
#   remove_filter :claimants
#   # filter :respondents
#   # filter :representatives
#   filter :uploaded_files, collection: proc {
#     UploadedFile.all.map { |file| file.filename}
#   }
#   # filter :primary_claimant
#   # filter :reference_contains
#   # filter :submission_reference_contains
#   filter :submission_channel, as: :check_boxes, collection: proc {
#     Claim.all.map(&:submission_channel).uniq
#   }
#   filter :case_type, as: :check_boxes, collection: proc {
#     Claim.all.map(&:case_type).uniq
#   }
#   filter :jurisdiction, as: :check_boxes, collection: proc { Claim.all.map(&:jurisdiction).uniq}
#   # filter :office_code_equals
#   # filter :name_of_recipient
#   remove_filter :administrator
#   # filter :created_at
#   # filter :updated_at
#   # filter :other_known_claimant_names
#   filter :discrimination_claims, as: :check_boxes, collection: proc { Claim.all.map(&:discrimination_claims).flatten.uniq }
#   # filter :pay_claims
#   # filter :desired_outcomes
#   # filter :other_claim_details
#   # filter :claim_details
#   # filter :other_outcome
#   filter :send_claim_to_whistleblowing_entity, as: :check_boxes
#   # filter :miscellaneous_information
#   filter :is_unfair_dismissal, as: :check_boxes
# # See permitted parameters documentation:
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
      table_for claim.claimants do
        column(:id) { |r| auto_link r, r.id }
        column :title
        column :first_name
        column :last_name
      end
    end

    panel('Respondents') do
      table_for claim.respondents do
        column(:id) { |r| auto_link r, r.id }
        column :name
      end
    end

    panel('Representatives') do
      table_for claim.representatives do
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
