class MakeReviewsAJoinTable < ActiveRecord::Migration[6.1]
  def up
    add_column :reviews, :user_id, :integer

    Review.all.each do |review|
      user = User.find_by(name: review.name)
      if user
        review.update(user_id: user.id)
      else
        review.delete
      end
    end

    remove_column :reviews, :name, :string
  end

  def down
    add_column :reviews, :name, :string

    Review.all.each do |review|
      user = User.find(review.user_id)
      review.update(name: user.name)
    rescue ActiveRecord::RecordNotFound => e
      review.delete
    end

    remove_column :reviews, :user_id, :integer
  end
end
