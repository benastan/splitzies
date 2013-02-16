Splitzies::Application.routes.draw do
  resources :roommate_notifications
  put '/roommate_notifications/:id/seen', controller: :roommate_notifications, action: :seen

  get '/users/friends' => 'users#friends', as: :invite_friends
  match '/users/next_step' => 'users#next_step', as: :next_step
  get 'roommates' => 'users#roommates', as: :roommates

  resources :expenses
  resources :households
  resources :invites, :only => [ :create, :show, :update ]
  resources :roommates, path: 'users', controller: :users

  resources :sessions, only: [:create, :index]

  match '/auth/facebook/callback' => 'sessions#create'
  get '/logout' => 'sessions#logout', as: 'logout'
  root :to => 'sessions#new', as: 'login'
end
