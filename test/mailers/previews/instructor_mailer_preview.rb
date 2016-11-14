class InstructorMailerPreview < ActionMailer::Preview
  def confirm_class
    instructor = Role.where(role: 7).first.user
    event = Event.last
    InstructorMailer.confirm_class(instructor, event)
  end
end
