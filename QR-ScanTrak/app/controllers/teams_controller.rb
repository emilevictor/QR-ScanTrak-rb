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
      @team = Team.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @team }
      end
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

  # GET /teams/1/edit
  def edit
        if current_user.try(:admin?)
    @team = Team.find(params[:id])
  end
  end

  # POST /teams
  # POST /teams.json
  def create
        if current_user.try(:admin?)
    @team = Team.new(params[:team])

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
    if user_signed_in?
      @user = current_user
      @team = Team.find(@user.team_id)
      @leaderboard = Team.getLeaderboard
      @scans = Scan.where(:team_id => @team.id)
      #@placement = @team.getPlacement(@leaderboard)
    else
      flash[:alert] = "You are not logged in!"

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
