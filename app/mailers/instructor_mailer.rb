class InstructorMailer < ApplicationMailer
  add_template_helper(MailersHelper)

  def confirm_class(instructor, event)
    @name    = instructor.full_name
    @email   = instructor.email
    @event   = event
    # template = event.format == 'Live Online' ? "instructor_class_confirm_online" : "instructor_class_confirm_onsite"
    # template = "instructor_class_confirm_onsite"
    template = "instructor_class_confirm_online"

    mail(
      to: @email,
      bcc: ["ashlie#{I18n.t('email')}", "leslie#{I18n.t('email')}", "operations#{I18n.t('email')}"],
      subject: "Welcome to NterOne!",
      template_path: "mailers",
      template_name: template
    )
  end
end
