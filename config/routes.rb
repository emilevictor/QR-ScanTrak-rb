QRScantrak::Application.routes.draw do


  get "home/index"

  match "/tags/error/" => "tags#error_not_admin"

  match "tags/:id/tagFound" => "tags#tagFound"
  match 'tags/:id/tagFoundQuizAnswered' => "tags#tagFoundQuizAnswered", :via => :post

  match 'tags/:id/scanSuccess' => 'tags#scanSuccess'



  #Home teams creation
  match '/createTeam' => "home#createTeam"
  match 'teams/AddPlayersToMyTeam' => 'teams#publicAddNewUsersToTeam'

  match 'teams/addPlayerToMyTeam' => 'teams#publicAddNewUsersToTeamProcessor'

  devise_for :users
  
  match 'teams/checkScore' => 'teams#checkTeamScore'

  match 'teams/removeTeamMembers' => 'teams#removeTeamMembers'

  #Removing team members
  match '/teams/remove_user_from_team/:teamID' => 'teams#remove_user_from_team'

  match '/tags/manualScan' => 'tags#manualScan'
  match '/tags/processScans' => 'tags#manualScanProcess'

  match '/admin' => 'admin#index'

  match 'teams/:id/edit/addUsers' => 'teams#addUsers'

  match 'teams/:id/edit/addUsersToTeam' => 'teams#addUsersToTeam', :via => :post

  scope "/admin" do
    #must be first line for production environment to work

    match 'tags/print' => 'tags#printTags'


    match 'teams/staticLeaderboard' => 'teams#staticLeaderboard'

    match 'teams/leaderboard' => 'teams#liveLeaderboard'


    resources :users
    resources :teams

    resources :tags
  end

  # Administration access to modify users.




  root :to => "home#index"





end
