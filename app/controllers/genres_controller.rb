class GenresController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_genre, only: [:show, :edit, :update, :destroy]

  def index
    @genres = Genre.order('name ASC')
  end

  def show
    @movies = @genre.movies
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to genres_url, notice: "Genre successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      redirect_to @genre, notice: "Genre successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @genre.destroy
    redirect_to genres_url, alert: "Genre successfully deleted!"
  end

private

  def genre_params
    params.require(:genre).permit(:name, :main_image)
  end

  def set_genre
    @genre = Genre.find_by!(slug: params[:id])
  end
end
