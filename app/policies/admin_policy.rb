class AdminPolicy < Struct.new(:user, :admin)
  # Tabs
  def my_account?
    user.has_any_role?(%i(member))
  end

  def sales?
    user.has_any_role?(%i(admin sales_rep sales_manager))
  end

  def my_classes?
    user.has_any_role?(%i(instructor))
  end

  def labs?
    user.has_any_role?(%i(admin lab_admin)) || user.company.present?
  end

  def lms?
    user.has_any_role?(%i(lms_business lms_manager lms_student))
  end

  # Actions
  def become?
    user.has_any_role?(%i(admin sales_rep sales_manager))
  end

  def orders?
    user.has_any_role?(%i(admin sales_rep sales_manager))
  end

  def orders_show?
    user.has_any_role?(%i(admin sales_rep sales_manager))
  end

  def classes?
    user.has_any_role?(%i(admin sales_rep sales_manager))
  end

  def classes_show?
    user.has_any_role?(%i(admin sales_rep sales_manager))
  end

  def courses?
    user.has_any_role?(%i(admin webmaster))
  end

  def website?
    user.has_any_role?(%i(admin marketing webmaster))
  end

  def people?
    user.has_any_role?(%i(admin sales_rep sales_manager))
  end

  def marketing?
    user.has_any_role?(%i(admin marketing webmaster))
  end

  def tools?
    user.has_any_role?(%i(admin sales_rep sales_manager webmaster lab_admin))
  end

  def cpl_log?
    user.has_any_role?(%i(admin))
  end

  def resources?
    user.has_any_role?(%i(admin))
  end

end
