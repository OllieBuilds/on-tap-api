Rails.application.routes.draw do
  # resources :beers, except: [:new, :edit]
  resources :examples, except: [:new, :edit]
  post '/sign-up' => 'users#signup'
  post '/sign-in' => 'users#signin'
  delete '/sign-out/:id' => 'users#signout'
  patch '/change-password/:id' => 'users#changepw'
  get '/find-beer/:query' => 'beers#findbeer'
  post '/add-beer' => 'beers#create'
  get '/my-beer' => 'beers#mybeers'
  delete '/my-beer/:bdb_id' => 'beers#destroy'
  patch '/toggle-favorite/' => 'beers#update'
  resources :users, only: [:index, :show]
end
