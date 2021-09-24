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
end
