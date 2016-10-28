class InsightPolicy < Struct.new(:user, :insight)
  def carts?
    user.admin?
  end
end
