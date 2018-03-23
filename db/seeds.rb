# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

controlled_resources = [:offices]
permissions = [:create, :read, :update, :delete].product(controlled_resources).map {|pair| pair.join('_')}

permissions.each do |p|
  Admin::Permission.find_or_create_by! name: p
end

admin_role = Admin::Role.find_or_create_by(name: 'administrator') do |role|
  role.is_admin = true
end

senior_role = Admin::Role.find_or_create_by!(name: 'senior') do |role|
  role.permissions << Admin::Permission.find_by(name: 'read_offices')
  role.permissions << Admin::Permission.find_by(name: 'update_offices')
  role.permissions << Admin::Permission.find_by(name: 'delete_offices')
  role.permissions << Admin::Permission.find_by(name: 'create_offices')
end

junior_role = Admin::Role.find_or_create_by!(name: 'junior') do |role|
  role.permissions << Admin::Permission.find_by(name: 'read_offices')
end


if Rails.env.development? || ENV.fetch('SEED_EXAMPLE_USERS', 'false') == 'true'
  Admin::User.find_or_create_by!(email: 'admin@example.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << admin_role unless user.roles.include?(admin_role)
  end

  Admin::User.find_or_create_by!(email: 'senioruser@example.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << senior_role unless user.roles.include?(senior_role)
  end

  Admin::User.find_or_create_by!(email: 'junioruser@example.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.roles << junior_role unless user.roles.include?(junior_role)
  end
end
