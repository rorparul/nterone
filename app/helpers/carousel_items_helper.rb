module CarouselItemsHelper
  def carousel_indicators(count)
    html = ''

    current_count = 0
    count.times do
      html += "<li>" +
                "<div class='#{'active' if current_count == 0}' data-target='#carousel-example-generic' data-slide-to='#{current_count}'></div>" +
              "</li>"

      current_count += 1
    end

    html.html_safe
  end
end
