source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.5', '>= 4.5.1'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'rack-cors'
gem 'haml-rails'
gem "image_processing", ">= 1.2"
gem "aws-sdk-s3", require: false
gem 'active_admin_datetimepicker'
gem 'stripe', '~> 5.37'
gem 'activeadmin_quill_editor', '~> 0.3.4'
gem 'active_model_serializers', '~> 0.10.12'
gem 'airbrake', '~> 11.0', '>= 11.0.3'
gem 'email_validator', '~> 2.2', '>= 2.2.3'
gem 'google-api-client', '~> 0.53.0'
gem 'sidekiq', '~> 6.3', '>= 6.3.1'
gem 'chartkick', '~> 4.1', '>= 4.1.2'
gem 'groupdate', '~> 5.2', '>= 5.2.2'
gem 'geocoder', '~> 1.7'
gem 'active_storage_validations', '~> 0.9.6'
gem 'cancancan', '~> 3.3'
gem 'pundit', '~> 1.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem 'activeadmin', '~> 2.9'
gem 'devise', '~> 4.8'
gem 'httparty', '~> 0.18.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-remote'
end

group :development, :test, :staging do
  gem 'sanitize_email', '~> 2.0', '>= 2.0.3'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
