Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "movies#index"

  %w(hits flops upcoming recent).each do |filter|
    get "movies/#{filter}" => "movies#index", filter: filter, as: "#{filter}_movies"
  end

  resources :movies do
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end
  resources :users
  resource :session, only: [:new, :create, :destroy]
  resources :genres
  get "signup" => "users#new"
  get "signin" => "sessions#new"
end
