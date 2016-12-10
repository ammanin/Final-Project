require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'twilio-ruby'
require 'alexa_skills_ruby'
require 'rake'
require 'haml'
require 'iso8601'
require 'google/apis/translate_v2'

# ----------------------------------------------------------------------

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end

#set :database, "sqlite3:db/smsilate_database.db"
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

#translation API
translate = Google::Apis::TranslateV2::TranslateService.new ENV["GOOGLE_TRANSLATE_ID"]
#translate.key = ENV["GOOGLE_TRANSLATE_ID"]
#result = translate.list_translations('Hello world!', 'es', source: 'en')
#puts result.translations.first.translated_text

# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

get "/" do
  401
end


get '/incoming_sms' do
	
  session["last_context"] ||= nil
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  result = translate.list_translations(body,'es', source: 'en')
  message = result.translations.first.translated_text
 twiml = Twilio::TwiML::Response.new do |r|
   r.Message message
 end
 twiml.text
	
end
# ----------------------------------------------------------------------
#     ERRORS
# ----------------------------------------------------------------------


=begin
get "/send_sms" do
	client.account.messages.create(
	:from => ENV["TWILIO_NUMBER"],
	:to => "+14129548714",
	:body => "Knock Knock!"
	)
	"Send Message"
end

require_relative './models/status_update'


# enable sessions for this project
enable :sessions


# ----------------------------------------------------------------------
#     AlexaSkillsRuby Handler
#     See https://github.com/DanElbert/alexa_skills_ruby
# ----------------------------------------------------------------------


class CustomHandler < AlexaSkillsRuby::Handler

  on_intent("GetCurrentStatus") do
    #slots = request.intent.slots
    
    current_status = StatusUpdate.all.last.message
    
    response.set_output_speech_text("It looks like: #{current_status} ")
    #response.set_simple_card("title", "content")
    logger.info 'GetCurrentStatus processed'
    
  end
  
  on_intent("AMAZON.HelpIntent") do
    #slots = request.intent.slots
    response.set_output_speech_text("You can ask me to tell you the current out of office status by saying current status. You can update your stats by saying tell out of office i'll be right back, i've gone home, i'm in a meeting, i'm here or i'll be back in 10 minutes")
    #response.set_simple_card("title", "content")
    logger.info 'GetCurrentStatus processed'
    
  end
  
  on_intent("BeRightBack") do
    response.set_output_speech_text("I've updated your status to be right back ")
    #response.set_simple_card("title", "content")
    logger.info 'BeRightBack processed'
    update_status "brb"
  end
  
  on_intent("GoneHome") do
    response.set_output_speech_text("I've updated your status to Gone Home ")
    #response.set_simple_card("title", "content")
    logger.info 'GoneHome processed'
    update_status "home"
  end
  
  on_intent("InAMeeting") do
    response.set_output_speech_text("I've updated your status to In a meeting ")
    #response.set_simple_card("title", "content")
    logger.info 'InAMeeting processed'
    update_status "meeting"
  end
  
  
  on_intent("Here") do
    response.set_output_speech_text("I've updated your status to Here ")
    #response.set_simple_card("Out of Office App", "Status is now.")
    logger.info 'Here processed'
    update_status "here"
  end

  on_intent("BackIn") do
    slots = request.intent.slots
    puts slots.to_s
    duration = ISO8601::Duration.new( request.intent.slots["duration"] ).to_seconds
      
    if duration > 60 * 60 * 24
      days = duration/(60 * 60 * 24).round
      response.set_output_speech_text("I've set you away for #{ days } days")
    elsif duration > 60 * 60 
      hours = duration/(60 * 60 ).round
      response.set_output_speech_text("I've set you away for #{ hours } hours")
    else 
      mins = duration/(60).round
      response.set_output_speech_text("I've set you away for #{ mins } minutes")
    end
    #response.set_simple_card("title", "content")
    logger.info 'BackIn processed'
    update_status "backin", duration
  end

end

# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

# THE APPLICATION ID CAN BE FOUND IN THE 

get '/' do
  @status = StatusUpdate.order( created_at: 'DESC' ).first
  haml :index
end

post '/' do
  content_type :json

  handler = CustomHandler.new(application_id: ENV['ALEXA_APPLICATION_ID'], logger: logger)

  begin
    handler.handle(request.body.read)
  rescue AlexaSkillsRuby::InvalidApplicationId => e
    logger.error e.to_s
    403
  end

end

# ----------------------------------------------------------------------
#     ERRORS
# ----------------------------------------------------------------------

configure :development do
  
  get '/test/:status' do
    update_status params[:status], nil
  end
  
  get '/test/:status/duration/:duration' do
    update_status params[:status], params[:duration].to_i
  end
  
end


error 401 do 
  "Not allowed!!!"
end

# ----------------------------------------------------------------------
#   METHODS
#   Add any custom methods below
# ----------------------------------------------------------------------

private

def update_status status, duration = nil
  
  message = get_message_for status, duration
  
  update = StatusUpdate.create( type_name: status, message: message, duration: duration )
  update.save

end 

def get_message_for status, duration

  message = "other/unknown"
  
  if status == "here"
    message = ENV['APP_USER'].to_s + " is in the office."
  elsif status == "backin"
    message = ENV['APP_USER'].to_s + " will be back in #{(duration/60).round} minutes"
  elsif status == "brb"
    message = ENV['APP_USER'].to_s + " will be right back"
  elsif status == "home"
    message = ENV['APP_USER'].to_s + " has left for the day. Check back tomorrow."
  elsif status == "meeting"
    message = ENV['APP_USER'].to_s + " is in a meeting."
  end
  
  message
  
end
=end