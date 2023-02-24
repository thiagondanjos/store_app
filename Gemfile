# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Ruby version
ruby '3.2.0'

# Rails version
gem 'rails', '~> 7.0.4', '>= 7.0.4.2'

# Gems
gem 'bootsnap', require: false
gem 'devise'
gem 'devise-jwt'
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'pry-rails'
gem 'puma', '~> 5.0'
gem 'pundit'
gem 'rack-cors'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :test do
  gem 'pundit-matchers'
  gem 'shoulda-matchers'
end

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end
