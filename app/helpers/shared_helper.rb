module SharedHelper
  def sign_in_or_account
    unless user_signed_in?
      text = t('shared.header.login')
      url  = new_user_session_path
    else
      text = t('shared.header.my_nterone')
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

  def flag_icon_of_current_region
    case session[:region]
    when 2
      flag_code = :ca
    when 1
      flag_code = :dm
    else
      flag_code = :us
    end

    flag_icon(flag_code, id: 'my-flag', class: 'strong', title: t('shared.header.change_region'))
  end
end
