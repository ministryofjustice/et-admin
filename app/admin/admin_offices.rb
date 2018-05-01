ActiveAdmin.register Admin::Office, as: 'ET Office' do
  config.batch_actions = false
  config.per_page = [10, 25, 50]
  config.sort_order = :name

  filter :name
  filter :code
  filter :office_post_codes

  actions :all
  includes :office_post_codes

  permit_params :code, :name, :address, :telephone, :email,
                :tribunal_type, :is_default, :is_processing_office

  index download_links: false, title: "Employment Tribunal Offices" do
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
    actions
  end

  show do
    default_main_content do
      row :postcodes do |o|
        o.office_post_codes.map(&:postcode).join(', ')
      end
    end
  end
end
