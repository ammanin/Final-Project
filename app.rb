require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'twilio-ruby'
require 'alexa_skills_ruby'
require 'rake'
require 'haml'
require 'iso8601'
require 'google/apis/translate_v2'
require 'httparty'
require 'easy_translate'

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
#translate = Google::Apis::TranslateV2::TranslateService.new 
EasyTranslate.api_key = ENV["GOOGLE_TRANSLATE_ID"]
#result = translate.list_translations('Hello world!', 'es', source: 'en')
#puts result.translations.first.translated_text

# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------


# ----------------------------------------------------------------------
#     ERRORS
# ----------------------------------------------------------------------



get "/send_sms" do
	client.account.messages.create(
	:from => ENV["TWILIO_NUMBER"],
	:to => "+14129548714",
	:body => "Knock Knock!"
	)
	"Send Message"
end


# enable sessions for this project
enable :sessions


# ----------------------------------------------------------------------
#     AlexaSkillsRuby Handler
#     See https://github.com/DanElbert/alexa_skills_ruby
# ----------------------------------------------------------------------

=begin
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

  on_intent("Translate") do
    slots = request.intent.slots
    puts slots.to_s
    translation_txt = (request.intent.slots["translation"] )
	language_input = (request.intent.slots["language"] )
	message = EasyTranslate.translate([translation_txt, :to => :language_input])
    #translate_url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=" + "en" + "&tl=" + "fr" + "&dt=t&q=" + URI.escape(translation)
  
	#response = HTTParty.get translate_url
    #puts response.to_s
    #response.to_s
	response.set_output_speech_text("#{translation_txt} in #{language_input} is #{message}" )  
	
	
    #response.set_simple_card("title", "content")

  end

end
=end

get "/" do 
  from_lang = "en"
  to_lang = params[:lang]
  word = params[:word]
  EasyTranslate.translate('hello world', :from => 'en', :to => 'es')

end 


# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

# THE APPLICATION ID CAN BE FOUND IN THE 

get '/' do
  
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




error 401 do 
  "Not allowed!!!"
end

# ----------------------------------------------------------------------
#   METHODS
#   Add any custom methods below
# ----------------------------------------------------------------------

private

