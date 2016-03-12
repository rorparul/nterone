namespace :vods do
  task :migrate_course => :environment do
    VideoOnDemand.all.each do |vod|
      if vod.course
        vod.intro             = vod.course.intro
        vod.overview          = vod.course.overview
        vod.outline           = vod.course.outline
        vod.intended_audience = vod.course.intended_audience
        vod.save
      end
    end
  end
end
