class InstructorMailer < ApplicationMailer
  add_template_helper(MailersHelper)

  def confirm_class(instructor, event)
    @name    = instructor.full_name
    @email   = instructor.email
    @event   = event
    template = event.format == 'Live Online' ? "instructor_class_confirm_online" : "instructor_class_confirm_onsite"

    mail(
      to: @email,
      bcc: [
        "ashlie@nterone.#{Rails.application.config.tld}",
        "leslie@nterone.#{Rails.application.config.tld}",
        "operations@nterone.#{Rails.application.config.tld}"
      ],
      subject: "Your NterOne Training Class",
      template_path: "mailers",
      template_name: template
    )
  end
end
