class Company < ActiveRecord::Base
  has_many :users
  has_many :lab_rentals

	validates :title, presence: true
end
