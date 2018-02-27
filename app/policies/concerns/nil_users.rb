module NilUsers
  extend ActiveSupport::Concern
  private

  def initialize(user, record)
    @user = user
    @record = record
  end

  def ensure_user_present
    raise Pundit::NotAuthorizedError, "User must be logged in" unless user.present?
  end

  # def this_method_name
  #   caller[5] =~ /`([^']*)'/ and $1
  # end
end
