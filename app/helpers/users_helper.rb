module UsersHelper
  def button_value(user)
    user.new_record? ? "Create Account" : "Update Account"
  end
end
