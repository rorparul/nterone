after :video_on_demands do
  VideoOnDemand.all.each do |vod|
    video_module = VideoModule.create(video_on_demand: vod, title: 'Introduction', position: 1)
    video_module2 = VideoModule.create(video_on_demand: vod, title: 'State Managment', position: 2)
    video_module2 = VideoModule.create(video_on_demand: vod, title: 'Immutable Data Structures', position: 3)
  end
end
