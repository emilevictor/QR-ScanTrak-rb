source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "pg", "~> 0.14.1"

# Devise - used for authentication

gem 'devise'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'geocoder'

gem "will_paginate", "~> 3.0.3"

gem "random-word", "~> 1.3.0"

#To fix the execJS error when running rake on a server
gem 'execjs'
gem 'therubyracer' 


#For qr code generation
gem 'rack-cache', :require => 'rack/cache'
gem 'dragonfly', '~>0.9.12'	
gem 'rqrcode_png'

#Global settings!
gem "rails_config"




# To use debugger
gem 'debugger'
gem "database_cleaner", "~> 0.8.0"


gem "rspec-rails", :group => [:test, :development]
gem 'rb-fsevent', '~> 0.9.1'
group :test, :development do
  gem "factory_girl"
  gem "capybara"
  gem "guard-rspec"
end

