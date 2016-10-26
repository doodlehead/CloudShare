Rails.application.routes.draw do
  
  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  #Generates helper methods such as signup_path
  
   resources :users
=begin
  Declares all common routes for the controller User:
  /users          -> GET, POST
  /users/new      -> GET
  /users/:id      -> GET, PUT/PATCH, DELETE 
  /users/:id/edit -> GET
  
  See http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions for reference
=end
  
end
