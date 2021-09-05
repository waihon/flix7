module UsersHelper
  def button_value(user)
    user.new_record? ? "Create Account" : "Update Account"
  end

  def profile_image(user)
   url = "https://secure.gravatar.com/avatar/#{user.gravatar_id}"
   image_tag(url, id: "profile-image", alt: user.name)
  end
end
