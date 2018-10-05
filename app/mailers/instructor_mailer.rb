class InstructorMailer < ApplicationMailer
  add_template_helper(MailersHelper)

  def confirm_class(instructor, event)
    @tld     = Rails.application.config.tld
    @name    = instructor.full_name
    @email   = instructor.email
    @event   = event
    template = Event::LIVE_ONLINE_FORMATS.include?(event.format) ? "instructor_class_confirm_online" : "instructor_class_confirm_onsite"

    mail(
      to: @email,
      bcc: [
        "leslie@nterone.#{@tld}",
        "operations@nterone.#{@tld}"
      ],
      subject: "Your NterOne Training Class",
      template_path: "mailers",
      template_name: template
    )
  end
end
