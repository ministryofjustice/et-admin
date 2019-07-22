ActiveAdmin.register Office, as: 'ET Office' do
  config.batch_actions = false
  config.filters = false
  config.per_page = [10, 25, 50]
  config.sort_order = :name

  permit_params :name, :address, :telephone, :email, :code
  includes :office_post_codes

  index title: "Employment Tribunal Offices" do
    id_column
    column 'Office', sortable: :name do |o|
      div b o.name
      div o.address
      div o.telephone
      div o.email
    end
    column :code
    bool_column 'Default', :is_default
    column :postcodes do |o|
      o.office_post_codes.map(&:postcode).join(', ')
    end
  end
end
