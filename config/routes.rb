Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "movies#index"
  resources :movies do
    resources :reviews
  end
  resources :users
  resource :session, only: [:new, :create, :destroy]
  get "signup" => "users#new"
end
