module VideoOnDemandHelper
  def video_completed_ratio(video_module, user)
    "#{video_module.watched_count(user)}/#{video_module.videos.count}"
  end

  def video_completed_class(video_module, user)
    return '' if video_module.videos.count == 0
    video_module.watched_count(user) == video_module.videos.count ? 'label-success' : 'label-default'
  end

  def exam_completed_ratio(video_module, user)
    "#{video_module.completed_exams_count_for(current_user)}/#{video_module.exams_count}"
  end

  def exam_completed_class(video_module, user)
    return '' if video_module.exams_count == 0
    video_module.completed_exams_count_for(current_user) == video_module.exams_count ? 'label-success' : 'label-default'
  end
end
