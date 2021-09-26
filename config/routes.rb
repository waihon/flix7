Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "movies#index"

  get "movies/hits" => "movies#index", filter: "hits", as: "hits_movies"
  get "movies/flops" => "movies#index", filter: "flops", as: "flops_movies"
  get "movies/upcoming" => "movies#index", filter: "upcoming", as: "upcoming_movies"
  get "movies/recent" => "movies#index", filter: "recent", as: "recent_movies"

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
