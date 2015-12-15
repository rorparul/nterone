class MyAdminController < ApplicationController
  def overview

  end

  def website
    @carousel_items = CarouselItem.page(1).per(5)
    @testimonials   = Testimonial.page(1).per(5)
  end
end
