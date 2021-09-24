class GenresController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  def index
    @genres = Genre.order('name ASC')
  end

  def show
    @genre = Genre.find(params[:id])
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
      render :new
    end
  end

private

  def genre_params
    params.require(:genre).permit(:name, :image_file_name)
  end
end
