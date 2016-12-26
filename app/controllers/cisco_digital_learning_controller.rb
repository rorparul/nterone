class CiscoDigitalLearningController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :callback

  def show
    video_module = VideoModule.find(params[:module_id])
    course       = video_module.video_on_demand

    if course.present? && current_user.active_video_on_demands.include?(course)
      course_slug = video_module.cdl_course_code
      aicc_sid    = SecureRandom.uuid
      aicc_url    = "https://www.nterone.com/cdl/callback"

      current_user.hacp_requests.create(aicc_sid: aicc_sid)
      # redirect_to "https://staging.certdev.net/nterone/#{course_slug}/users/auth/hacp/callback?aicc_sid=#{aicc_sid}&aicc_url=#{aicc_url}"
      redirect_to "https://ondemandelearning.cisco.com/nterone/#{course_slug}/users/auth/hacp/callback?aicc_sid=#{aicc_sid}&aicc_url=#{aicc_url}"
    else
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to :back
    end
  end

  def callback
    Rails.logger.info("HACP CALLBACK: #{params}")

    session_id    = params[:session_id]
    valid_request = HacpRequest.find_by(aicc_sid: session_id, used: false)

    if valid_request.present?
      valid_request.toggle(:used)

      @user       = valid_request.user
      @error      = 0
      @error_text = "Successful"
    else
      @user       = nil
      @error      = 1
      @error_text = "Failure"
    end

    render '/cisco_digital_learning/response.txt.erb', layout: false, content_type: 'text/plain'
  end
end
