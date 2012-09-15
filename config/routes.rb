QRScantrak::Application.routes.draw do


  #must be first line for production environment to work

  match '/tags/manualScan' => 'tags#manualScan'
  match '/tags/processScans' => 'tags#manualScanProcess'


  match 'tags/print' => 'tags#printTags'

  #Home teams creation
  match '/createTeam' => "home#createTeam"
  match 'teams/AddPlayersToMyTeam' => 'teams#publicAddNewUsersToTeam'

  match 'teams/addPlayerToMyTeam' => 'teams#publicAddNewUsersToTeamProcessor'

  match 'teams/checkScore' => 'teams#checkTeamScore'

  match 'teams/leaderboard' => 'teams#leaderboard'

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
