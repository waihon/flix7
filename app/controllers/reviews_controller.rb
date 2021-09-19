class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to movie_reviews_url(@movie), notice: "Thanks for your review!"
    else
      render :new
    end
  end

  def edit
    session[:referer_url] ||= request.referer
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to session.delete(:referer_url), notice: "Review successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    session[:referer_url] ||= request.referer
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to session.delete(:referer_url), notice: "Review successfully deleted!"
  end

private

  def review_params
    params.require(:review).permit(:stars, :comment)
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end
end
