Rails.application.routes.draw do
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/u/new', to: 'users#new', as: :new_user
  post '/u/new', to: 'users#create', as: nil
  resources :users, param: :username, path: :u, only: [:show]
  resources :subs, param: :slug, path: :r, only: [:show, :new, :create, :destroy] do
    resources :posts, only: [:new]
  end
  resources :posts, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    resources :comments, only: [:index, :new, :create, :edit, :update, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'subs#show', {slug: 'all'}
end
