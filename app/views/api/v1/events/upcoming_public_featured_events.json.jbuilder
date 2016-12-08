json.array! @events do |event|
  if event.course
    json.platform do
      json.id    event.course.platform.id
      json.title event.course.platform.title
    end
    json.full_title          event.course.full_title
    json.platform_course_url platform_course_url(event.course.platform, event.course)
    json.start_date          event.start_date
    json.end_date            event.end_date
    json.length              event.length
    json.format              event.format
    json.language            event.language
    json.city                event.city
    json.state               event.state
    json.street              event.street
    json.price               event.price
    json.video_preview       event.course.video_preview
    json.link_to_cart        link_to_cart(event)

    if event.course.pdf.url.present?
      json.pdf_url course_download_platform_courses_url(event.course.platform, event.course)
    end
  end
end
