class AddSlugToGenres < ActiveRecord::Migration[6.1]
  def up 
    add_column :genres, :slug, :string

    Genre.find_each do |genre|
      genre.update!(slug: genre.name.parameterize)
    end
  end

  def down
    remove_column :genres, :slug
  end
end
