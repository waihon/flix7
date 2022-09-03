class UsersController < ApplicationController
  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.not_admins
  end

  def show
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    # Only admin users can delete user accounts.
    # Sign out only if an admin user deleted their own account.
    session[:user_id] = nil if current_user?(@user)
    redirect_to root_url, alert: "Account successfully deleted!"
  end

private

  def require_correct_user
    @user = User.find_by!(username: params[:id])
    redirect_to root_url unless current_user?(@user) || current_user_admin?
  end

  def user_params
    if current_user_admin?
      params.require(:user).permit!
    else
      params.require(:user).
        permit(:name, :email, :username, :password, :password_confirmation)
    end
  end

  def set_user
    @user = User.find_by!(username: params[:id])
  end
end
