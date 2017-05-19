Rails.application.routes.draw do
  get 'users/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

  get 'users/:id/friends', to: 'users#friends'
  post 'users/:id/addfriend', to: 'users#add_friend'
  post 'users/:id/addfriendbyname', to: 'users#add_friends_by_name'
  post 'sessions' => 'sessions#create'
  delete 'sessions/:id' => 'sessions#destroy'
end
