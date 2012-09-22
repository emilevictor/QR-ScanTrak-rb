require 'bcrypt'

class TeamsController < ApplicationController
  before_filter :authenticate_user!
  include BCrypt

  # GET /teams
  # GET /teams.json
  def index
    if current_user.try(:admin?)
      @teams = current_user.currentGame.teams.all

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
      @team = @user.currentGame().teams.find(params[:id])
      @leaderboard = Team.getLeaderboard(current_user)
      @scans = @user.currentGame().scans.where(:team_id => @team.id)
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
    @leaderboard = Team.getLeaderboard(current_user)
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
      @user = current_user

      #encrypt provided password
      @team.password = BCrypt::Password.create(@team.password)

      respond_to do |format|
        if @team.save
          if not current_user.try(:admin?)
            @team.users << @user
            if not @user.currentGame().nil?
              @user.currentGame().teams << @team

              #current_user.currentGame().save
              #@team.save
              #@team.game = current_user.currentGame()
            else
              flash[:notice] = "You need to be in a game for that to work!"
              redirect_to home_index_path
            end
          else
            if not current_user.currentGame().nil?
              @user.currentGame().teams << @team
            else
              flash[:alert] = "You are currently not in a game, you need to join one first."
              redirect_to home_index_path
            end

          end
          
          @user.created_teams << @team
          @user.save
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
      @team = current_user.currentGame().teams.find(params[:id])
      #@team = Team.find(params[:id])
      @users = User.all

      render view: "addUsers"
    end
  end

  #Adding new members to the team, for public players
  def publicAddNewUsersToTeam
    #Check that the user is logged in, is in a team, and that the
    #team has less then Settings.maxTeamMembers players.
    if user_signed_in?
      @team = current_user.currentGame().teams.find(current_user.team.id)
      #@team = Team.find(current_user.team.id)

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
        @team = current_user.currentGame().teams.find(params[:team_id])
        #@team = Team.find(params[:team_id])
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
    #@team = Team.find(params[:id])
    @team = current_user.currentGame().teams.find(params[:id])
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
      @team = current_user.currentGame().teams.where(:user_id => @user.id).first
      #@team = Team.find(@user.team_id)
      @leaderboard = Team.getLeaderboard(@user)
      @scans = current_user.currentGame().scans.where(:team_id => @team.id)
      #@scans = Scan.where(:team_id => @team.id)
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
          @team = current_user.currentGame().teams.find(params[:id])

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

  # Allows those who created teams to administer those who are in those teams.
  def removeTeamMembers
    @team = current_user.currentGame().teams.where(:user_id => current_user.id)
    #If the user is signed in, AND is in a team, AND created the team.
    if user_signed_in? and not @team.nil? and not current_user.created_teams.where(:id => @team.id).first.empty?



      respond_to do |format|
        format.html #removeTeamMembers.html.erb
      end


    elsif @team.nil?
      flash[:alert] = "You aren't in a team, therefore you can't remove team members."


    elsif current_user.created_teams.where(:id => @team.id).empty?

      flash[:alert] = "You didn't create the team, as a result you don't have the right to remove people from it."
      redirect_to home_index_path


    else
      flash[:alert] = "You aren't signed in!"
      redirect_to new_user_session_path

    end
  end

  #TODO: make this safe so that people can't just willy nilly delete people from other teams.
  # POST TO ME!
  def remove_user_from_team
    team = current_user.currentGame().teams.find(params[:teamID])
   #team = Team.find(params[:teamID])
     
    numberRemoved = 0
    params.each do |key,value|
      if (splitKey = key.split(" "))[0] == "USERID"
        user = team.users.find(splitKey[1].to_i)
        #puts "----------- USER #{splitlitKey[1]}"
        if user and team and not current_user.created_teams.where(:id => team.id).empty?
          team.users.delete(user)
          numberRemoved = numberRemoved + 1
        end
      end
    end

    flash[:notice] = "Successfully removed members from team."
    redirect_to teams_removeTeamMembers_path

    #Rails.logger.warn "Param #{key}: #{value}"
  end


  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
        #If the user has either created or the team or is an admin
        if current_user.try(:admin?) or not current_user.created_teams.where(:id => params[:id]).empty?
          @team = Team.find(params[:id])
          @team.destroy

          respond_to do |format|
            format.html { redirect_to teams_url }
            format.json { head :no_content }
          end
        end
  end

end
