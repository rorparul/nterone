class Event < ActiveRecord::Base
  belongs_to :course
  belongs_to :instructor

  def length
    if self.end_date && self.start_date
      (self.end_date - self.start_date).to_i + 1
    end
  end

  def self.guaranteed_events
    where(guaranteed: true).order(:start_date)
  end

  validates :course_id, :price, :format, presence: true
end
