module UsersHelper
  def button_value(user)
    user.new_record? ? "Create Account" : "Update Account"
  end

  def profile_image(user, size=80)
   url = "https://secure.gravatar.com/avatar/#{user.gravatar_id}?s=#{size}"
   image_tag(url, id: "profile-image", alt: user.name)
  end
end
