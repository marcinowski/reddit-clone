Rails.application.routes.draw do
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :subs, param: :slug, only: [:show, :new, :create, :destroy] do
    resources :posts, only: [:new]
  end
  resources :posts, only: [:index, :show, :edit, :update, :destroy, :new, :create] do
    resources :comments, only: [:index, :new, :create, :edit, :update, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'subs#show', {slug: 'all'}
end
