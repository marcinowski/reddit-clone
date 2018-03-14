Rails.application.routes.draw do
  post '/ratings', to: 'ratings#vote'
  get '/search', to: 'search#index'
  get '/search/results', to: 'search#results'
  get '/search/results_users', to: 'search#results_users'
  get '/search', to: 'search#index'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/u/new', to: 'users#new', as: :new_user
  post '/u/new', to: 'users#create', as: nil
  resources :users, param: :username, path: :u, only: [:show]
  resources :subs, param: :slug, path: :r, only: [:show, :new, :create, :destroy, :edit, :update] do
    resources :posts, only: [:new]
  end
  get '/r/:slug/mod', to: 'subs#mod', as: :mod_sub
  post '/subscribe', to: 'subs#subscribe'
  post '/unsubscribe', to: 'subs#unsubscribe'
  get '/admin', to: 'admin#index'
  get '/admin/users', to: 'admin#users'
  post '/admin/action', to: 'admin#action'
  post '/admin/mod_action', to: 'admin#mod_action'
  resources :posts, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    resources :comments, only: [:index, :new, :create, :edit, :update, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'subs#show', {slug: 'all'}
end
