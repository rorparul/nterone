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

  def welcome_experts_exchange
    user = User.second
    CustomMailer.welcome_experts_exchange(user)
  end
end
