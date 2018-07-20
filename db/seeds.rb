# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

controlled_resources = [:offices, :jobs, :acas, :acas_download_logs,
  :addresses, :atos_files, :claims, :claimants, :exports, :exported_files,
  :representatives, :respondents, :responses, :uploaded_files, :users, :acas_check_digits,
  :reference_number_generators]
permissions = [:create, :read, :update, :delete, :import].product(controlled_resources).map { |pair| pair.join('_') }.sort

permissions.each do |p|
  Admin::Permission.find_or_create_by! name: p
end

admin_role = Admin::Role.find_or_create_by(name: 'Admin') do |role|
  role.is_admin = true
end

super_user_role = Admin::Role.find_or_create_by!(name: 'Super User') do |role|
  role.permissions << Admin::Permission.find_by(name: 'read_offices')
  role.permissions << Admin::Permission.find_by(name: 'update_offices')
  role.permissions << Admin::Permission.find_by(name: 'delete_offices')
  role.permissions << Admin::Permission.find_by(name: 'create_offices')
  role.permissions << Admin::Permission.find_by(name: 'read_acas')
  role.permissions << Admin::Permission.find_by(name: 'read_acas_download_logs')
  role.permissions << Admin::Permission.find_by(name: 'read_acas_check_digits')
  role.permissions << Admin::Permission.find_by(name: 'read_reference_number_generators')
  role.permissions << Admin::Permission.find_by(name: 'create_reference_number_generators')

  role.permissions << Admin::Permission.find_by(name: 'read_claims')
  role.permissions << Admin::Permission.find_by(name: 'update_claims')
  role.permissions << Admin::Permission.find_by(name: 'delete_claims')
  role.permissions << Admin::Permission.find_by(name: 'create_claims')

  role.permissions << Admin::Permission.find_by(name: 'read_responses')
  role.permissions << Admin::Permission.find_by(name: 'update_responses')
  role.permissions << Admin::Permission.find_by(name: 'delete_responses')
  role.permissions << Admin::Permission.find_by(name: 'create_responses')

  role.permissions << Admin::Permission.find_by(name: 'read_users')
  role.permissions << Admin::Permission.find_by(name: 'update_users')
  role.permissions << Admin::Permission.find_by(name: 'delete_users')
  role.permissions << Admin::Permission.find_by(name: 'create_users')
end

developer_role = Admin::Role.find_or_create_by!(name: 'Developer') do |role|
  role.permissions << Admin::Permission.find_by(name: 'read_offices')
  role.permissions << Admin::Permission.find_by(name: 'update_offices')
  role.permissions << Admin::Permission.find_by(name: 'delete_offices')
  role.permissions << Admin::Permission.find_by(name: 'create_offices')

  role.permissions << Admin::Permission.find_by(name: 'read_addresses')
  role.permissions << Admin::Permission.find_by(name: 'update_addresses')
  role.permissions << Admin::Permission.find_by(name: 'delete_addresses')
  role.permissions << Admin::Permission.find_by(name: 'create_addresses')

  role.permissions << Admin::Permission.find_by(name: 'read_claims')
  role.permissions << Admin::Permission.find_by(name: 'update_claims')
  role.permissions << Admin::Permission.find_by(name: 'delete_claims')
  role.permissions << Admin::Permission.find_by(name: 'create_claims')

  role.permissions << Admin::Permission.find_by(name: 'read_responses')
  role.permissions << Admin::Permission.find_by(name: 'update_responses')
  role.permissions << Admin::Permission.find_by(name: 'delete_responses')
  role.permissions << Admin::Permission.find_by(name: 'create_responses')

  role.permissions << Admin::Permission.find_by(name: 'read_claimants')
  role.permissions << Admin::Permission.find_by(name: 'update_claimants')
  role.permissions << Admin::Permission.find_by(name: 'delete_claimants')
  role.permissions << Admin::Permission.find_by(name: 'create_claimants')

  role.permissions << Admin::Permission.find_by(name: 'read_representatives')
  role.permissions << Admin::Permission.find_by(name: 'update_representatives')
  role.permissions << Admin::Permission.find_by(name: 'delete_representatives')
  role.permissions << Admin::Permission.find_by(name: 'create_representatives')

  role.permissions << Admin::Permission.find_by(name: 'read_respondents')
  role.permissions << Admin::Permission.find_by(name: 'update_respondents')
  role.permissions << Admin::Permission.find_by(name: 'delete_respondents')
  role.permissions << Admin::Permission.find_by(name: 'create_respondents')

  role.permissions << Admin::Permission.find_by(name: 'read_uploaded_files')
  role.permissions << Admin::Permission.find_by(name: 'update_uploaded_files')
  role.permissions << Admin::Permission.find_by(name: 'delete_uploaded_files')
  role.permissions << Admin::Permission.find_by(name: 'create_uploaded_files')

  role.permissions << Admin::Permission.find_by(name: 'read_atos_files')


  role.permissions << Admin::Permission.find_by(name: 'read_acas')
  role.permissions << Admin::Permission.find_by(name: 'read_acas_download_logs')
  role.permissions << Admin::Permission.find_by(name: 'read_acas_check_digits')
  role.permissions << Admin::Permission.find_by(name: 'read_jobs')
  role.permissions << Admin::Permission.find_by(name: 'read_reference_number_generators')
  role.permissions << Admin::Permission.find_by(name: 'create_reference_number_generators')
end

user_role = Admin::Role.find_or_create_by!(name: 'User') do |role|
  role.permissions << Admin::Permission.find_by(name: 'read_offices')
  role.permissions << Admin::Permission.find_by(name: 'read_acas_download_logs')
  role.permissions << Admin::Permission.find_by(name: 'read_acas')
  role.permissions << Admin::Permission.find_by(name: 'read_acas_check_digits')
  role.permissions << Admin::Permission.find_by(name: 'read_reference_number_generators')
  role.permissions << Admin::Permission.find_by(name: 'create_reference_number_generators')
end


if Rails.env.development? || ENV.fetch('SEED_EXAMPLE_USERS', 'false') == 'true'
  Admin::User.find_or_create_by!(email: 'admin@example.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << admin_role unless user.roles.include?(admin_role)
  end

  Admin::User.find_or_create_by!(email: 'developer@example.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << developer_role unless user.roles.include?(developer_role)
  end

  Admin::User.find_or_create_by!(email: 'senioruser@example.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << super_user_role unless user.roles.include?(super_user_role)
  end

  Admin::User.find_or_create_by!(email: 'superuser@example.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << super_user_role unless user.roles.include?(super_user_role)
  end

  Admin::User.find_or_create_by!(email: 'junioruser@example.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << user_role unless user.roles.include?(user_role)
  end
  Admin::User.find_or_create_by!(email: 'user@example.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << user_role unless user.roles.include?(user_role)
  end
end
