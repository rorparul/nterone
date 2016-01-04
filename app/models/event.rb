class Event < ActiveRecord::Base
  belongs_to :course
  belongs_to :instructor

  def self.guaranteed_events
    where(guaranteed: true).order(:start_date)
  end

  def self.guaranteed_upcoming_events
    where("active = :active and guaranteed = :guaranteed and start_date >= :start_date", { active: true, guaranteed: true, start_date: Time.now })
  end

  def length
    if self.end_date && self.start_date
      (self.end_date - self.start_date).to_i + 1
    end
  end

  validates :course, :price, :format, presence: true
  validates_associated :course
end
