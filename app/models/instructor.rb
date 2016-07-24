class Instructor < ActiveRecord::Base
  enum status: { employee: 0, contractor: 1 }

  belongs_to :platform
  has_many   :events
  has_many   :video_on_demands

  validates_presence_of   :first_name, :last_name, :email
  validates_uniqueness_of :email

  def full_name
    "#{first_name} #{last_name}"
  end
end
