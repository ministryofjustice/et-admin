# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

controlled_resources = [:offices, :jobs, :acas, :acas_download_logs,
  :addresses, :atos_files, :claims, :claimants, :exports, :exported_files,
  :roles, :representatives, :respondents, :responses, :uploaded_files, :users,
  :acas_check_digits, :reference_number_generators]

permissions = [:create, :read, :update, :delete, :import].product(controlled_resources).map { |pair| pair.join('_') }.sort

permissions.each do |p|
  Admin::Permission.find_or_create_by! name: p
end

admin_role = Admin::Role.find_by(name: 'Admin')
super_user_role = Admin::Role.find_by!(name: 'Super User')
developer_role = Admin::Role.find_by!(name: 'Developer')
user_role = Admin::Role.find_by!(name: 'User')


if Rails.env.development? || ENV.fetch('SEED_EXAMPLE_USERS', 'false') == 'true'
  Admin::User.find_or_create_by!(email: 'admin@example.com') do |user|
    user.name = 'Administrator'
    user.department = 'DCD'
    user.username = 'admin'
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << admin_role unless user.roles.include?(admin_role)
  end

  Admin::User.find_or_create_by!(email: 'developer@example.com') do |user|
    user.name = 'Developer'
    user.department = 'DCD'
    user.username = 'developer'
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << developer_role unless user.roles.include?(developer_role)
  end

  Admin::User.find_or_create_by!(email: 'superuser@example.com') do |user|
    user.name = 'Super User'
    user.department = 'DCD'
    user.username = 'superuser'
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << super_user_role unless user.roles.include?(super_user_role)
  end

  Admin::User.find_or_create_by!(email: 'user@example.com') do |user|
    user.name = 'User'
    user.department = 'DCD'
    user.username = 'user'
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << user_role unless user.roles.include?(user_role)
  end
end
