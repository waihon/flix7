class FavoritesController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def create
    @movie.favorites.create!(user: current_user)
    # or append to the through association
    # @movie.fans << current_user

    redirect_to @movie, notice: "Thanks for fav'ing!"
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy

    redirect_to @movie, notice: "Sorry you unfaved it!"
  end

private

  def set_movie
    # Raise an exception if a movie with the specific slug could not be found.
    # If an exception is raised in production, we'll get a 404 page which is
    # exactly what we want if a movie with the given slug isn't found.
    @movie = Movie.find_by(slug: params[:movie_id])
  end
end
