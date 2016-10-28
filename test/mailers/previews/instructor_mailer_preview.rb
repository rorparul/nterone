class InstructorMailerPreview < ActionMailer::Preview
  def confirm_class
    instructor = Role.where(role: 7).first.user
    event = Event.first
    InstructorMailer.confirm_class(instructor, event)
  end
end
