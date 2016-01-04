class Testimonial < ActiveRecord::Base
  belongs_to :course

  validates :quotation, presence: true
end
