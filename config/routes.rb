Rails.application.routes.draw do
  devise_for :users
  resources :posts do
    get '/posts/:post_id/download', to: 'posts#download', as: 'download' ## make this work!!!
  	member do
  		get "like", to: "posts#upvote"
  		get "dislike", to: "posts#downvote"
  	end
  	resources :comments
  	resources :heads
  end

  root 'posts#index'
end
