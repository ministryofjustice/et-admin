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
