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

    link_to '#', id: 'sign-in-or-account', class: 'btn btn-blue-gradient dropdown-toggle', role: 'button', data: { toggle: 'dropdown' }, 'aria-haspopup': 'true', 'aria-expanded': 'false' do
      "#{text} <span class='caret'></span>".html_safe
    end
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

  def active_vendors_in_region
    Platform.active.current_region.order(:title)
  end

  def back_button
    ("<button id='back' class='btn btn-blue-gradient btn-padded center-block'>" +
      "Back" +
    "</button>" +
    "<script>" +
      "$('#back').on('click', function() {" +
        "location.replace(document.referrer);" +
      "});" +
    "</script>").html_safe
  end
end
