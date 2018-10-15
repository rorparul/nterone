class CustomMailerPreview < ActionMailer::Preview
  def welcome
    user = User.second
    CustomMailer.welcome(user)
  end

  def welcome_es
    I18n.with_locale(:es) do
      welcome
    end
  end
end
