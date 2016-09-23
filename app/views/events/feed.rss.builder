xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "NterOne"
    xml.description "#{t('events.feed_rss.description')}"
    xml.link "#{t('events.feed_rss.link')}"

    @events.each do |event|
      xml.item do
        xml.title event.course.full_title
        xml.description "#{event.start_date.strftime('%-m/%-d/%y')} to #{event.end_date.strftime('%-m/%-d/%y')}"
        xml.category event.course.platform.title
        if event.guaranteed
          xml.category "#{t('events.feed_rss.guaranteed')}"
        end
        xml.link platform_course_url(event.course.platform, event.course)
      end
    end
  end
end
