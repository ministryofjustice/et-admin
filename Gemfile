source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.3'
# Azure deployment so we need this
gem 'azure_env_secrets', git: 'https://github.com/ministryofjustice/azure_env_secrets.git', tag: 'v0.1.3'
# Use postgres as the database for Active Record
gem 'pg', '~> 1.0'
gem 'iodine', '~> 0.7.43'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'sprockets', '~> 4.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.10'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'sidekiq', '~> 6.1'
gem 'sidekiq-cron', '~> 1.1'
gem 'sidekiq-failures', '~> 1.0'
gem 'sentry-raven', '~> 3.1'

# Azure gem for active storage
gem 'azure-storage-blob', '~> 2.0', '>= 2.0.1'

# Use uk_postcode to validate postcodes for manual generation
gem 'uk_postcode', '~> 2.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 4.1'
  gem 'listen', '~> 3.4'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'devise', '~> 4.7'
gem 'activeadmin', '~> 2.0'
gem 'activeadmin_addons', '~> 1.4'
gem 'active_admin_import', '~> 4.1'
gem 'pundit', '~> 2.0'
gem 'httparty', '~> 0.17'
gem 'dotenv-rails', '~> 2.7'


gem 'et_azure_insights', '0.2.12', git: 'https://github.com/hmcts/et-azure-insights.git', tag: 'v0.2.12'
gem 'application_insights', git: 'https://github.com/microsoft/ApplicationInsights-Ruby.git', ref: '5db6b4'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
