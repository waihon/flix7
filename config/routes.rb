Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "movies#index"

  get "movies/:filter" => "movies#index",
    constraints: { filter: /hits|flops|upcoming|recent/ },
    as: :filtered_movies

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
