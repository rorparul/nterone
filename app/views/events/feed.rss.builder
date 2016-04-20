xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "NterOne"
    xml.description "Upcoming Classes"
    xml.link "https://www.nterone.com"

    @events.each do |event|
      xml.item do
        xml.title event.course.full_title
        xml.description "#{event.start_date.strftime('%-m/%-d/%y')} to #{event.end_date.strftime('%-m/%-d/%y')}"
        xml.guaranteed event.course.platform.title
        if event.guaranteed
          xml.category "GTR"
        end
        xml.link platform_course_url(event.course.platform, event.course)
      end
    end
  end
end
