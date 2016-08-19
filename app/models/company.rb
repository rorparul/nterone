class Company < ActiveRecord::Base
	has_many :user_companies,     dependent:  :destroy
  has_many :users,              through:    :user_companies

	validates :title, presence: true
end
