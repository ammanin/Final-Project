source 'https://rubygems.org'

gem 'sinatra'
gem 'json'
gem 'shotgun'
gem 'activerecord'
gem 'sinatra-activerecord' # excellent gem that ports ActiveRecord for Sinatra
gem 'twilio-ruby'
gem "rake"


# to avoid installing postgres use 
# bundle install --without production

group :development, :test do
  gem 'sqlite3'
  gem 'dotenv'
end

group :production do
  gem 'pg'
end
