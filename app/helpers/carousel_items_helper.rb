module CarouselItemsHelper
  def carousel_indicators(count)
    html = ''

    current_count = 0
    count.times do
      html += "<li>" +
                "<div class='#{'active' if current_count == 0}' data-target='#carousel-example-generic' data-slide-to='#{current_count}'><div/>" +
              "<li/>"

      current_count += 1
    end

    html.html_safe
  end
  # 
  # def carousel_items(carousel_items)
  #   html = ''
  #
  #   current_count = 0
  #   carousel_items.each do |carousel_item|
  #     html += "<div class='item #{'active' if current_count == 0}'>" +
  #               img_tag carousel_item.image.file.processed_image.url +
  #               "<div class='carousel-caption'>" +
  #                 carousel_item.caption +
  #               "<div/>" +
  #             "<div/>"
  #
  #     current_count += 1
  #   end
  #
  #   html.html_safe
  # end
end
