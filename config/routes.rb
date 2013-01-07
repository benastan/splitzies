Splitzies::Application.routes.draw do
  get '/users/friends' => 'users#friends', as: :invite_friends
  match '/users/next_step' => 'users#next_step', as: :next_step

  resources :expenses
  resources :households
  resources :invites, :only => [ :create, :show, :update ]
  resources :roommates, path: 'users', controller: :users

  match '/auth/facebook/callback' => 'sessions#create'
  root :to => 'sessions#new'
end
