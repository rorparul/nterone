class CiscoDigitalLearningController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :callback

  def show
    # "https://ondemandelearning.cisco.com/vendor/course/users/auth/hacp/callback?aicc_sid=...&amp;aicc_url=..."
    # ccnp-route

    course = VideoOnDemand.find_by(cisco_digital_learning: true, cdl_course_code: params[:cdl_course_code])

    if course.present? && current_user.purchased?(course)
      course_slug = course.cdl_course_code
      aicc_sid    = SecureRandom.uuid
      aicc_url    = "https://www.nterone.com/cdl/callback"

      current_user.hacp_requests.create(aicc_sid: aicc_sid)
      redirect_to "https://staging.certdev.net/nterone/#{course_slug}/users/auth/hacp/callback?aicc_sid=#{aicc_sid}&aicc_url=#{aicc_url}"
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
