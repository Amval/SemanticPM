Rails.application.routes.draw do

  get 'sessions/new'

  root 'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'signup'   => 'users#new'
  post 'courses/create_messages'   => 'courses#create_messages'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :users
  resources :courses, only: [:create, :destroy]

end
