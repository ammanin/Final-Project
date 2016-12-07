class User < ActiveRecord::Base
	has_many :dailywords
	has_many :translations	
end