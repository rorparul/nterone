module SharedHelper
  def sign_in_or_account
    unless user_signed_in?
      link_to t('shared.header.login'), new_user_session_path, id: 'sign-in-or-account', class: 'btn btn-blue-gradient', role: 'button'
    else
      dashboard_link = if current_user.admin? || current_user.partner? || current_user.sales?
                         admin_classes_path
                       elsif current_user.instructor?
                         instructor_classes_path
                       else
                         my_account_plan_path
                       end

      ("<div class='btn-group' role='group'>" +
        (link_to '#', class: 'btn btn-blue-gradient btn-padded dropdown-toggle', role: 'button', data: { toggle: 'dropdown' }, 'aria-haspopup': 'true', 'aria-expanded': 'false' do
          "#{t('shared.header.my_nterone')}<span class='caret'></span>".html_safe
        end) +
        "<ul class='dropdown-menu dropdown-menu-right'>" +
          "<li>" +
            link_to(t('shared.header.dashboard'), dashboard_link) +
          "</li>" +
          (if user_signed_in? && (current_user.admin? || current_user.sales?)
            "<li>#{link_to(t('shared.header.tasks'), tasks_path, remote: true)}</li>".html_safe
          end || '') +
          "<li>" +
            link_to(t('shared.header.account_settings'), edit_user_registration_path) +
          "</li>" +
          "<hr>" +
          "<li>" +
            link_to(t('shared.header.sign_out'), logout_path, class: 'text-danger') +
          "</li>" +
        "</ul>" +
      "</div>").html_safe
    end
  end

  def flag_icon_of_current_region
    case session[:region]
    when 2
      flag_code = :ca
    when 1
      flag_code = :do
    else
      flag_code = :us
    end

    flag_icon(flag_code, id: 'my-flag', class: 'strong', title: t('shared.header.change_region'))
  end

  def active_vendors_in_region
    Platform.active.current_region.order(:title).select { |vendor| vendor.welcome_category.present? }
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
