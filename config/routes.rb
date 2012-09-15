QRScantrak::Application.routes.draw do


  #must be first line for production environment to work
  if Rails.env.production?

    match '/scantrak/' => 'home#index'
    match '/scantrak/tags/print' => 'tags#printTags'
    match 'scantrak//tags/manualScan' => 'tags#manualScan'
    match 'scantrak//tags/processScans' => 'tags#manualScanProcess'


    match 'scantrak/tags/print' => 'tags#printTags'
  
    #Home teams creation
    match 'scantrak/createTeam' => "home#createTeam"
    match 'scantrak/teams/AddPlayersToMyTeam' => 'teams#publicAddNewUsersToTeam'
  
    match 'scantrak/teams/addPlayerToMyTeam' => 'teams#publicAddNewUsersToTeamProcessor'
  
    match 'scantrak/teams/checkScore' => 'teams#checkTeamScore'
  
    match 'scantrak/teams/leaderboard' => 'teams#leaderboard'
  
    resources :teams
  
    resources :tags
  
    get "home/index"
  
  
    devise_for :users
  
    root :to => "home#index"
  
  
  
    match "scantrak/tags/error/" => "tags#error_not_admin"
  
    match "scantrak/tags/:id/tagFound" => "tags#tagFound"
    match 'scantrak/tags/:id/tagFoundQuizAnswered' => "tags#tagFoundQuizAnswered", :via => :post
  
    match 'scantrak/tags/:id/scanSuccess' => 'tags#scanSuccess'
  
    match 'scantrak/teams/:id/edit/addUsers' => 'teams#addUsers'
  
  
  
    match 'scantrak/teams/:id/edit/addUsersToTeam' => 'teams#addUsersToTeam', :via => :post

  else 
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
