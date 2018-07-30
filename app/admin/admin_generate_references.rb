ActiveAdmin.register Admin::GenerateReference, as: 'Generate Reference' do
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
  show title: "Your Reference" do
    h1 "ET1 Postal Fee Group Reference Number: #{generate_reference.reference}"
    h1 generate_reference.postcode
  end

  permit_params :postcode

  form decorate: true, title: 'Generate Fee Group Reference Number for Postal ET1' do |f|
    input :postcode, label: "Claimant's Workplace Postcode"
    actions do
      submit value: 'Submit'
    end
  end

  controller do
    def index
      redirect_to new_admin_generate_reference_path
    end

    def create
      postcode = params[:admin_generate_reference][:postcode]
      generate_reference_model = Admin::GenerateReferenceService.call(postcode)
      redirect_to admin_generate_reference_path(id: generate_reference_model.reference)
    end

    def find_resource
      Admin::GenerateReference.new(reference: params[:id])
    end
  end
end
