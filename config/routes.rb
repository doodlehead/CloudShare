Rails.application.routes.draw do
  
  resources :assets do
    member do
      get 'sharing'
      post 'share'
      get 'share_index' 
      #share_index displays the users that a file has been shared too
    end
    collection do
      get 'shared_files'
    end
  end
  
  get 'sessions/new'

  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/files', to: "static_pages#file_upload"
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get 'assets/get/:id', to: 'assets#get'
  delete '/assets/:id/unshare/:sId', to: 'assets#unshare', as: :unshare_asset

  #sharing renders the form, share takes the post request
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
