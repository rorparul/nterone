class MyAdminPolicy < Struct.new(:user, :my_admin)
  def classes?
    @user.admin?
  end
end
