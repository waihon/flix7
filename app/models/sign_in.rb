class SignIn < ActiveType::Object
  attribute :email_or_username, :string
  attribute :password, :string

  validate :validate_user_exists
  validate :validate_password_correct

  def user
    User.find_by(email: email_or_username) ||
    User.find_by(username: email_or_username)
  end

  private

  def validate_user_exists
    if user.blank?
      errors.add(:email_or_username, 'User not found')
    end
  end

  def validate_password_correct
    if user && !user.authenticate(password)
      errors.add(:password, 'Incorrect password')
    end
  end
end