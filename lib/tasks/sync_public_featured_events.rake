namespace :sync do
  task :public_featured_events => :environment do
    hosts = %w(www.nterone.com www.nterone.la)
    hosts = %w(nterone.dev:3000)  if Rails.env.development?
    # current_host = `hostname`.strip
    # sync_hosts = hosts - [current_host]

    events = []
    hosts.each do |host|
      url_scheme = Rails.env.development? ? "http" : "https"
      api_events_url = "#{url_scheme}://#{host}/api/v1/events/upcoming_public_featured_events.json"
      json_events = JSON.parse(open(api_events_url).read)
      json_events.each do |json_event|
        events << {
          full_title:          json_event['full_title'],
          platform_course_url: json_event['platform_course_url'],
          start_date:          json_event['start_date'],
          end_date:            json_event['end_date'],
          length:              json_event['length'],
          format:              json_event['format'],
          language:            json_event['language'],
          city:                json_event['city'],
          state:               json_event['state'],
          street:              json_event['street'],
          price:               json_event['price'],
          video_preview:       json_event['video_preview'],
          link_to_cart:        json_event['link_to_cart'],
          pdf_url:             json_event['pdf_url'],
          platform_id:         json_event['platform']['id'],
          platform_title:      json_event['platform']['title']
        }
      end
    end
    PublicFeaturedEvent.destroy_all
    PublicFeaturedEvent.create(events)
  end
end
