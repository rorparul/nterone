class CustomMailerPreview < ActionMailer::Preview
  def welcome
    user = User.first
    CustomMailer.welcome(user)
  end
end
