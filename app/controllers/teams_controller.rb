require 'bcrypt'

class TeamsController < ApplicationController
  include BCrypt

  # GET /teams
  # GET /teams.json
  def index
    if current_user.try(:admin?)
      @teams = Team.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @teams }
      end
    else
      flash[:alert] = "You are not logged in as an admin"
      redirect_to :controller => "home", :action => "index"
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    if current_user.try(:admin?)
      @user = current_user
      @team = Team.find(params[:id])
      @leaderboard = Team.getLeaderboard
      @scans = Scan.where(:team_id => @team.id)
      @placement = @team.getPlacement(@leaderboard)
      @scans = @team.scans.paginate(:page => params[:page])

      respond_to do |format|
        format.json {render json: {placement: @placement, scans: @scans, team:@team, tags: @tags}}
        format.html { render action: "checkTeamScore" }
      end

    else
      flash[:alert] = "Here's your team's score"
      redirect_to :controller => 'teams', :action => 'checkTeamScore', :id => current_user.team_id

    end
  end

  # GET /teams/new
  # GET /teams/new.json
  def new
    if current_user.try(:admin?)
      @team = Team.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @team }
      end
    end
  end


  #Current leaderboard, static

  def staticLeaderboard
    @leaderboard = Team.getLeaderboard
    respond_to do |format|
      format.html
      format.json {render json: @leaderboard}
    end

  end

  def liveLeaderboard
    if current_user.try(:admin?)
    #nothing here right now, just in case we need extra information later.
      respond_to do |format|
        format.html

      end
    else
      flash[:alert] = "You must be an administrator to view the leaderboard."
      redirect_to home_index_path
    end
  end

  # GET /teams/1/edit
  def edit
        if current_user.try(:admin?)
    @team = Team.find(params[:id])
  end
  end

  # POST /teams
  # POST /teams.json
  def create
    #Keeping in mind that this can be accessed by normal users
    #Ensure that they are not in a team already.
    @user = current_user
    flash[:alert] = ""


    if (not @user.nil? and @user.team_id.nil?) or current_user.try(:admin?)


      @team = Team.new(params[:team])

      if not current_user.try(:admin?)

        @team.users << current_user
      end

      #encrypt provided password
      @team.password = BCrypt::Password.create(@team.password)

      respond_to do |format|
        if @team.save
          format.html { redirect_to @team, notice: 'Team was successfully created.' }
          format.json { render json: @team, status: :created, location: @team }
        else
          format.html { render action: "new" }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end

    else 
      flash[:alert] = "You are already in a team, and you are trying to create a new one!"
      redirect_to :controller => "home", :action => "index"
    end
  
  end

  # GET /teams/1/edit/addUsers
  def addUsers
    if current_user.try(:admin?)
      @team = Team.find(params[:id])
      @users = User.all

      render view: "addUsers"
    end
  end

  #Adding new members to the team, for public players
  def publicAddNewUsersToTeam
    #Check that the user is logged in, is in a team, and that the
    #team has less then Settings.maxTeamMembers players.
    if user_signed_in?
      @team = Team.find(current_user.team_id)

      if @team.users.count < Settings.maxTeamMembers

        @numberLeft = Settings.maxTeamMembers - @team.users.count

        render view: "publicAddNewUsersToTeam"

      else
        flash[:alert] = "Your team is full, therefore you cannot add more players!"
        redirect_to :controller => 'home', :action => 'index'
      end


    else
      #User is not signed in
      flash[:alert] = "You are not signed in."
      redirect_to :controller => 'devise/sessions', :action => 'new'
    end

  end

  def publicAddNewUsersToTeamProcessor
    @user = User.where(:email => params[:email]).first

    #if that user doesn't exist, bounce back with error
    if @user.nil?

      flash[:notice] = "There is no user with the email address #{params[:email]}"
      redirect_to :controller => 'teams', :action => 'publicAddNewUsersToTeam'
    else
      #user exists, let's just add them to the team.
      if @user.team.nil?
        #If user is not already in a team
        @team = Team.find(params[:team_id])
        if @team.users.count >= Settings.maxTeamMembers
            #If the team is already full
          flash[:alert] = "Your team is full, you can't add more members."
          redirect_to :controller => 'teams', :action => 'checkTeamScore'


        end

        if not @team.nil?
          #If the team exists (i.e. there was no error in the form)
          @team.users << @user
          flash[:notice] = "Added player #{@user.first_name} #{@user.last_name} to your team."
          redirect_to :controller => 'teams', :action => 'checkTeamScore'
        else
          flash[:notice] = "There was an error getting the team ID, let the admin know."
          redirect_to :controller => 'teams', :action => 'publicAddNewUsersToTeam'
        end

      else
        #If the user is already in a team
        flash[:notice] = "That user is already in a team! Tell them to leave their existing team first."
        redirect_to :controller => 'teams', :action => 'publicAddNewUsersToTeam'
      end
      

    end
  end

  #The processing function

  # POST /teams/1/edit/addUsers
  def addUsersToTeam
    @team = Team.find(params[:id])
    #puts "HELLO?"
    params.each do |key,value|
      if (splitKey = key.split(" "))[0] == "USERID"
        #puts "----------- USER #{splitKey[1]}"
        @team.users << User.find(splitKey[1.to_i])
      end

      #Rails.logger.warn "Param #{key}: #{value}"
    end
    if @team.save
      redirect_to @team, notice: 'Players successfully added to team'
    else
      redirect_to @team, error: 'Couldn\'t add players to team'
    end
  end



  #Check team score
  def checkTeamScore
    if user_signed_in? and not current_user.team_id.nil?
      @user = current_user
      @team = Team.find(@user.team_id)
      @leaderboard = Team.getLeaderboard
      @scans = Scan.where(:team_id => @team.id)
      @placement = @team.getPlacement(@leaderboard)
      @scans = @team.scans.paginate(:page => params[:page])

      respond_to do |format|
        format.json {render json: {placement: @placement, scans: @scans, team:@team, tags: @tags}}
        format.html { render action: "checkTeamScore" }
      end

    else
      flash[:alert] = "You are not logged in, or you aren't in a team."
      redirect_to :controller => 'home', :action => 'index'

    end

  end


  # PUT /teams/1
  # PUT /teams/1.json
  def update
        if current_user.try(:admin?)
    @team = Team.find(params[:id])

    respond_to do |format|
      #if the password has been changed, recompute it.
      if params[:team][:password] != @team.password
        params[:team][:password] = BCrypt::Password.create(params[:team][:password])
      end

      if @team.update_attributes(params[:team])
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
        if current_user.try(:admin?)
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end
  end

end
