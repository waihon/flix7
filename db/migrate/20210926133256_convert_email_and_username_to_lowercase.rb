class ConvertEmailAndUsernameToLowercase < ActiveRecord::Migration[6.1]
  def up 
    User.find_each do |user|
      user.email = user.email.downcase
      user.username = user.username.downcase
      user.save!
    end
  end

  def down
  end
end
