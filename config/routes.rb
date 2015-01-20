Rails.application.routes.draw do
  devise_for :users
  resources :posts do
  	member do
      get "download", to: "posts#download"
  		get "like", to: "posts#upvote"
  		get "dislike", to: "posts#downvote"
  	end
  	resources :comments
  	resources :heads
  end

  root 'posts#index'
end
