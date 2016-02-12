Rails.application.routes.draw do
  devise_for :users
  resources :posts do
  	member do
      get "download", to: "posts#download"
      get "embed", to: "posts#embed"
  	end
  	resources :comments
  	resources :heads
  end

  root 'posts#index'
end
