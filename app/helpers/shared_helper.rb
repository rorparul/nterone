module SharedHelper
  def sign_in_or_account
    unless user_signed_in?
      text = 'Login'
      url  = new_user_session_path
    else
      text = 'My NterOne'
      if current_user.admin? || current_user.partner? || current_user.sales?
        url = admin_classes_path
      elsif current_user.instructor?
        url = instructor_classes_path
      else
        url = my_account_plan_path
      end
    end

    link_to text, url, id: 'sign-in-or-account', class: 'btn btn-blue-gradient', role: 'button'
  end
end
