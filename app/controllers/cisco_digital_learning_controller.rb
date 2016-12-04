class CiscoDigitalLearningController < ApplicationController
  def show
    # "https://ondemandelearning.cisco.com/vendor/course/users/auth/hacp/callback?aicc_sid=...&amp;aicc_url=..."
    # ccnp-route

    course = VideoOnDemand.find_by(cisco_digital_learning: true, cdl_course_code: params[:cdl_course_code])

    if course.present? && current_user.purchased?(course)
      course_slug = course.cdl_course_code
      aicc_sid    = SecureRandom.uuid
      aicc_url    = "https://www.nterone.com/cdl/callback"

      HacpRequest.create(aicc_sid: aicc_sid)
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

      @error      = 0
      @error_text = "Successful"
    else
      @error      = 1
      @error_text = "UUID already used"
    end

    render '/hacp_responses/response.txt.erb', layout: false, content_type: 'text/plain'
  end
end
