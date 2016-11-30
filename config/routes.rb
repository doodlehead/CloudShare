Rails.application.routes.draw do
  
  resources :assets
  get 'sessions/new'

  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  #Session routing
  
   resources :users
   #Generates helper methods such as signup_path
=begin
  Declares all common routes for the controller User:
  /users          -> GET, POST
  /users/new      -> GET
  /users/:id      -> GET, PUT/PATCH, DELETE 
  /users/:id/edit -> GET
  
  See http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions for reference
=end
  
end
