QRScantrak::Application.routes.draw do

  match 'teams/checkScore' => 'teams#checkTeamScore'

  resources :teams

  resources :tags

  get "home/index"


  devise_for :users

  root :to => "home#index"

  match "/tags/error/" => "tags#error_not_admin"

  match "tags/:id/tagFound" => "tags#tagFound"
  match 'tags/:id/tagFoundQuizAnswered' => "tags#tagFoundQuizAnswered", :via => :post

  match 'tags/:id/scanSuccess' => 'tags#scanSuccess'

  match 'teams/:id/edit/addUsers' => 'teams#addUsers'

  match 'teams/:id/edit/addUsersToTeam' => 'teams#addUsersToTeam', :via => :post

end