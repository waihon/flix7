class RemoveImageFileNameFromGenres < ActiveRecord::Migration[6.1]
  def change
    remove_column :genres, :image_file_name, :string
  end
end
