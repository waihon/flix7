class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @page_title = movies_filter_title
    @movies = Movie.send(movies_filter).with_query(params[:query])
  end

  def show
    @review = @movie.reviews.new
    @fans = @movie.fans
    @genres = @movie.genres
    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: "Movie successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: "Movie successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_url, alert: "Movie successfully deleted!"
  end

private

  def movie_params
    params.require(:movie).
      permit(:title, :description, :rating, :released_on, :total_gross,
             :director, :duration, :main_image, genre_ids: [])
  end

  def movies_filter
    whitelisted_scopes = %w[upcoming recent hits flops]
    if params[:filter].in? whitelisted_scopes
      params[:filter]
    else
      :released
    end
  end

  def movies_filter_title
    "#{movies_filter.to_s.titlecase} Movies"
  end

  def set_movie
    # Raise an exception if a movie with the specific slug could not be found.
    # If an exception is raised in production, we'll get a 404 page which is
    # exactly what we want if a movie with the given slug isn't found.
    @movie = Movie.find_by!(slug: params[:id])
  end

  def record_not_found
    redirect_to movies_url, alert: "Movie '#{params[:id]}' not found!"
  end
end
