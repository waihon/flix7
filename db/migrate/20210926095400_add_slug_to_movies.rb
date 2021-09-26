class AddSlugToMovies < ActiveRecord::Migration[6.1]
  def up 
    add_column :movies, :slug, :string

    Movie.find_each do |movie|
      movie.update!(slug: movie.title.parameterize)
    end
  end

  def down
    remove_column :movies, :slug
  end
end
