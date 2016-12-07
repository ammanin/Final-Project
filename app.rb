require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'twilio-ruby'
require 'rake'


# ----------------------------------------------------------------------

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end

set :database, "sqlite3:db/smsilate_database.db"
require_relative './models/user'
require_relative './models/dailyword'

# require any models 
# you add to the folder
# using the following syntax:
# require_relative './models/<model_name>'


# enable sessions for this project
enable :sessions
client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]
enable :sessions

# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

get "/" do
  401
end
get "/send_sms" do
	client.account.messages.create(
	:from => ENV["TWILIO_NUMBER"],
	:to => "+14129548714",
	:body => "Knock Knock!"
	)
	"Send Message"
end
# ----------------------------------------------------------------------
#     ERRORS
# ----------------------------------------------------------------------


error 401 do 
  "Not allowed!!!"
end


# ----------------------------------------------------------------------
#   METHODS
#   Add any custom methods below
# ----------------------------------------------------------------------

private

# for example 
def square_of int
  int * int
end