module VideoOnDemandHelper
  def video_completed_ratio(video_module, user)
    "#{video_module.watched_count(user)}/#{video_module.videos.count}"
  end

  def video_completed_class(video_module, user)
    return 'label-default' if video_module.videos.count == 0
    video_module.watched_count(user) == video_module.videos.count ? 'label-success' : 'label-default'
  end

  def exam_completed_ratio(video_module, user)
    "#{video_module.completed_exams_count_for(user)}/#{video_module.assign_quizzes.count}"
  end

  def exam_completed_class(video_module, user)
    return 'label-default' if video_module.assign_quizzes.count == 0
    video_module.completed_exams_count_for(current_user) == video_module.assign_quizzes.count ? 'label-success' : 'label-default'
  end

  def quiz_disabled_class(video, user)
    return 'disabled' if !user
    video.status_for(user) == 'completed' ? '' : 'disabled'
  end

  def lms_exam_disabled_class(lms_exam, user)
    return 'disabled' if !user
    lms_exam.completed_by?(user) ? '' : 'disabled'
  end


  def vod_overal_progress(vod, user)
    "#{vod.overal_progress_percent_for(user)}% (#{vod.overal_progress_count_for(user)}/#{vod.overal_all_count_for(user)})"
  end

  def get_videos_quizzes(object)
    videos             = object.videos
    assign_quizzes     = object.assign_quizzes
    videos_and_quizzes = videos + assign_quizzes
    videos_and_quizzes.sort { |a, b| a.position && b.position ? a.position <=> b.position : a.position ? -1 : 1 }
  end

end
