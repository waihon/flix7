class SessionsController < ApplicationController
  def new
    build_sign_in
    @page_title = "Sign In"
  end

  def create
    build_sign_in
    if @sign_in.save
      user = @sign_in.user
      session[:user_id] = user.id
      redirect_to session[:intended_url] || user, notice: "Welcome back, #{user.name}!"
      session[:intended_url] = nil
    else
      flash.now[:alert] = "Invalid email/password combination!"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "You are now signed out!"
  end

  private

  def build_sign_in
    @sign_in = SignIn.new(sign_in_params)
  end

  def sign_in_params
    sign_in_params = params[:sign_in]
    sign_in_params.permit(:email_or_username, :password) if sign_in_params
  end
end