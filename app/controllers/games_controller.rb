class GamesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_user_is_admin, :only => [:show, :new, :edit, :create, :update, :destroy]
  

  # USER ONLY JAZZ

  def joinAGame

  end

  def makeDefaultGame
    current_user.default_game_id = params[:id].to_i

    puts "\n\n\n\n\n"

    puts "#{current_user.default_game_id} #{params[:id].to_i}"

    puts "\n\n\n\n\n"

    current_user.save
    flash[:notice] = "Set your default game"
    redirect_to games_listPlayersGames_path
  end

  def listPlayersGames
    @games = current_user.games
  end

  def joinGameProcess
    #If the name given was an integer
    #debugger
    if params[:gameID].to_i != 0

      begin

        @game = Game.find(params[:gameID].to_i)

      rescue Exception => ex
        @game = nil
      end

      if not @game.nil?

        if not @game.users.where(id: current_user.id).any?

          if @game.requiresPassword
            if params[:password].eql?@game.password
              @game.users << current_user
              current_user.default_game_id = @game.id
              current_user.save
              flash[:notice] = "You joined the game #{@game.name}"
              redirect_to home_index_path
            else
              flash[:alert] = "The password for that game is wrong!"
              redirect_to games_joinAGame_path
              return
            end
          else
            @game.users << current_user
            current_user.default_game_id = @game.id
            current_user.save
            
            flash[:notice] = "Successfully joined the game #{@game.name}"
            redirect_to home_index_path and return
          end
          
        else
          flash[:notice] = "All good, you're already in that game."
          redirect_to home_index_path
        end
        #If this happens, it must be the code.
      else
        flash[:alert] = "A game with that ID doesn't exist. Try again?"
        redirect_to games_joinAGame_path
      end




    else
      begin

        @game = Game.where(:shortID => params[:gameID]).first

      rescue Exception => ex
        @game = nil
      end
      

      if not @game.nil?

        if not @game.users.where(id: current_user.id).any?

          if @game.requiresPassword
            if params[:password].eql?@game.password
              @game.users << current_user
              current_user.default_game_id = @game.id
              current_user.save
              flash[:notice] = "You joined the game #{@game.name}"
              redirect_to home_index_path
            else
              flash[:alert] = "The password for that game is wrong!"
              redirect_to games_joinAGame_path
              return
            end
          else
            @game.users << current_user
            current_user.default_game_id = @game.id
            current_user.save
            
            flash[:notice] = "Successfully joined the game #{@game.name}"
            redirect_to home_index_path and return
          end
          
        else
          flash[:notice] = "All good, you're already in that game."
          redirect_to home_index_path
        end
        #If this happens, it must be the code.
      else
        flash[:alert] = "A game with that ID doesn't exist. Try again?"
        redirect_to games_joinAGame_path
      end
    end

  end


  # ADMIN ONLY JAZZ

  # GET /games
  # GET /games.json
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  private

  def check_user_is_admin
    if not current_user.try(:admin?)
      flash[:alert] = "You are not an admin, you can't do that."
      redirect_to home_index_path
    end
  end

end
