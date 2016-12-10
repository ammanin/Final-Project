class StatusUpdate < ActiveRecord::Base
  
  validates_presence_of :type_name
  validates_presence_of :message
  
end