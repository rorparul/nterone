class Testimonial < ActiveRecord::Base
  belongs_to :course

  validates_presence_of :quotation
end
