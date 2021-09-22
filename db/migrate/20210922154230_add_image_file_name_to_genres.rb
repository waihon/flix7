class AddImageFileNameToGenres < ActiveRecord::Migration[6.1]
  def change
    add_column :genres, :image_file_name, :string, default: "placeholder.png"

  end
end
