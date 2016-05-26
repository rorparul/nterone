after :videos do
  Video.all.each do |video|
    LmsExam.create(
      title: "Exam for #{video.title}",
      description: 'Exam description',
      exam_type: 0,
      video: video,
      video_module: video.video_module
    )
  end

  VideoOnDemand.all.each do |vod|
    LmsExam.create(
      title: 'Course Test',
      description: 'Test description',
      exam_type: 1,
      video_on_demand: vod
    )
  end
end
