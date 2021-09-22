class GenresController < ApplicationController
  def show
    @genre = Genre.find(params[:id])
    @movies = @genre.movies
  end
end
