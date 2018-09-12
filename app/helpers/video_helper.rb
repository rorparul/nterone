module VideoHelper
  def video_status(user, video)
    return if !user

    status = video.status_for(user) || ''
    "<span class='status-circle #{status}' style='margin-left: 21px;' />".html_safe
  end

  def wistia_video_id(video)
    video.try(:embed_code).scan(/wistia_async_([a-zA-Z0-9]+)/).flatten.first
  end
end
