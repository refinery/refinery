# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'hanami', git: 'https://github.com/hanami/hanami', branch: 'unstable'

group :development do
  gem 'irb'
end

group :test, :development do
  gem 'pry'
end

group :test do
  gem 'capybara'
  gem 'rspec'
end

group :production do
  gem 'falcon'
end
