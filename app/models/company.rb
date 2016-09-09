class Company < ActiveRecord::Base
  has_many :users
  has_many :lab_rentals
  has_many :lab_courses

	validates :title, presence: true

  before_create :create_slug

  private

  def create_slug
    self.slug = self.title.downcase.gsub(' ', '-')
  end
end
