class Company < ActiveRecord::Base
	validates :title, presence: true
end
