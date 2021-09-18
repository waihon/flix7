require 'rails_helper'

describe ReviewsController do
  before do
    @movie = Movie.create!(movie_attributes)
    @user = User.create!(user_attributes)
    @review = @movie.reviews.create(review_attributes(user: @user))
  end

  context "when not signed in" do
    before do
      session[:user_id] = nil  
    end

    it "cannot access index" do
      get :index, params: { movie_id: @movie }

      expect(response).to redirect_to(signin_url)
    end

    it "cannot access new" do
      get :new, params: { movie_id: @movie }

      expect(response).to redirect_to(signin_url)
    end

    it "cannot access create" do
      post :create, params: { movie_id: @movie }

      expect(response).to redirect_to(signin_url)
    end

    it "cannot access edit" do
      get :edit, params: { movie_id: @movie, id: @review }

      expect(response).to redirect_to(signin_url)
    end

    it "cannot access update" do
      patch :update, params: { movie_id: @movie, id: @review }

      expect(response).to redirect_to(signin_url)
    end

    it "cannot access destroy" do
      delete :destroy, params: { movie_id: @movie, id: @review }

      expect(response).to redirect_to(signin_url)
    end
  end
end