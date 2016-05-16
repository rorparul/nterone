module VideoHelper
  def video_status(user, video)
    return if !user

    status = video.status_for(user) || ''
    "<span class='status-circle #{status}' />".html_safe
  end
end
