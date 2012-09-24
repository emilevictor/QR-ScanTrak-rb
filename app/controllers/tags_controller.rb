require 'rubygems'
require 'rqrcode'


class TagsController < ApplicationController
  before_filter :handleAdminWithNoGame
  #before_filter :authenticate_admin!
  # GET /tags
  # GET /tags.json
  #include 'Pngqr'

  def index
    if current_user.try(:admin?)
      @qrCodes = []
      if not current_user.currentGame().nil?
        if not current_user.currentGame().tags.nil?
          @tags = current_user.currentGame().tags.paginate(:page => params[:page]) 
        else
          flash[:alert] = "There are no tags yet, so you need to create the first one!"
          redirect_to new_tag_path and return
        end
        
      else
        flash[:alert] = "You aren't in a game yet, so you need to create one."
        redirect_to new_game_path and return
      end
      

      #host = request.host_with_port
      #@tags.each do |tag|
        #if Rails.env.production?
          #qrCodeString = "http://" + request.host_with_port + "/tags/" + tag.uniqueUrl + "/tagFound"

        #else
          #qrCodeString = "http://" + request.host_with_port + "/tags/" + tag.uniqueUrl + "/tagFound"


        #end
        #@indivQR = RQRCode::QRCode.new(qrCodeString, :size => 10)
        #@qrCodes.push(@indivQR)

        #tag.createdByUser = User.find(tag.createdBy).email

      #end
      
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @tags }
      end

    else
      flash[:notice] = 'You need admin privileges to go there.'
      redirect_to :controller => "home", :action => "index"
    end
    
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
      @tag = Tag.find(params[:id])
      if not @tag.nil?


        if Rails.env.production?
          qrCodeString = "http://" + request.host_with_port + "/tags/" + @tag.uniqueUrl + "/tagFound"

        else
          qrCodeString = "http://" + request.host_with_port + "/tags/" + @tag.uniqueUrl + "/tagFound"
        end
        @indivQR = RQRCode::QRCode.new(qrCodeString, :size => 10)

        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @tag }
        end

      else
        flash[:alert] = "There was a problem getting the tag which you specified.
         Maybe it doesn't exist?"
        redirect_to :controller => "home", :action => "index"

      end



  end

  #The page a user sees when they scan a tag

  def tagFound
    if user_signed_in?
      @tag = Tag.where(:uniqueUrl => params[:id]).first

      #Check that the user is playing this game
      if not @tag.game == current_user.currentGame()
        flash[:alert] = "You haven't signed up for the game that that tag is for, sign up, join in and have fun."
        redirect_to games_joinAGame_path and return
      end

      @user = current_user

      #Team of the current user.
      #If the current user's team is in the current game


      if not @user.teams.where(:game_id => @user.currentGame().id).empty?
        @team = @user.teams.where(:game_id => @user.currentGame().id).first
      else
        flash[:alert] = "You just tried to scan a tag, but you aren't in a team yet! Join a team first."
        #redirect_to :controller => "home", :action => "index"
      end

      #If you *are* in a team
      if not @team.nil?

        if user_signed_in? and Scan.where(:team_id => @team.id, :tag_id => @tag.id).first.nil?
        
          @numberOfTeams = Scan.where(:tag_id => @tag.id).count
          respond_to do |format|
            format.html
            format.json {render tag: @tag, numberOfTeams: @numberOfTeams}
          end
        else
          flash[:alert] = "You have already scanned that tag!"
          redirect_to :controller => "home", :action => "index"
        end


      else
        flash[:alert] = "You just tried to scan a tag, but you aren't in a team yet! Join a team first."
        
          redirect_to :controller => "home", :action => "index"

      end

      

    else
      flash[:notice] = "Welcome to QR Scantrak. If this is your first time playing the game, create an account and check out the description on the front page!"
      redirect_to new_user_session_path

    end
    
  end

  def tagFoundQuizAnswered

    if user_signed_in?
      #Check that the user hasn't scanned this yet.
      @user = current_user
      #Team of the current user.
      @team = @user.teams.where(:game_id => @user.currentGame().id).first

      if @team.nil?
        flash[:notice] = "You aren't in a team yet, so you need to join a new one to scan a tag."
        redirect_to home_index_path and return
      end

      @tag = Tag.where(:uniqueUrl => params[:id]).first

      #Check that tag hasn't been scanned yet.
      if Scan.where(:team_id => @team.id, :tag_id => @tag.id).empty?
        if params[:answer].nil?
          answer = ""
        else
          answer = params[:answer]
        end
        if (answer == @tag.quizAnswer) or (@tag.quizQuestion.empty?)
          #cool... They got the answer correct or there was no question.
          #Now we can create a scan,
          #add it to their team.



          @scan = Scan.new

          @scan.save

          @scan.game = current_user.currentGame()

          @team.scans << @scan

          @tag.scans << @scan


          flash[:notice] = "You successfully scanned the tag"
          redirect_to :controller => "teams", :action => "checkTeamScore"

        else
          flash[:alert] = "You got the answer wrong!"
          redirect_to :controller => "tags", :action => "tagFound", :id => @tag.uniqueUrl
        end

      elsif current_user.try(:admin?) and Scan.where(:team_id => @team.id, :tag_id => @tag.id).first.nil?
        if (params[:answer] == @tag.quizAnswer) or (@tag.quizQuestion.empty?)
          #cool... They got the answer correct or there was no question.
          #Now we can create a scan,
          #add it to their team.

          @scan = Scan.new

          @scan.save

          @scan.game = current_user.currentGame()

          @team.scans << @scan

          @tag.scans << @scan


          flash[:notice] = "You successfully scanned the tag"
          redirect_to :controller => "teams", :action => "checkTeamScore"

        else
          flash[:alert] = "You got the answer wrong!"
          redirect_to :controller => "tags", :action => "tagFound", :id => @tag.uniqueUrl
        end

      else
        flash[:notice] = "You have already scanned that tag"
        redirect_to :controller => "home", :action => "index"

      end
    else
      #user isn't signed in
      redirect_to new_user_session_path
    end
    
    
  end

  #Successfully scanned tag

  def scanSuccess


  end


  # GET /tags/new
  # GET /tags/new.json
  def new
    if current_user.try(:admin?)
      @tag = Tag.new
      @tag.uniqueUrl = (0...20).map{ ('a'..'z').to_a[rand(26)] }.join

      #Check for uniqueness in the tag url.

      while (!Tag.where(:uniqueUrl => @tag.uniqueUrl).first.nil?)
        @tag.uniqueUrl = (0...20).map{ ('a'..'z').to_a[rand(26)] }.join
      end

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @tag }
      end
    else
      flash[:notice] = 'You need admin privileges to go there.'
      redirect_to :controller => "home", :action => "index"
    end
  end

  # GET /tags/1/edit
  def edit
    if current_user.try(:admin?)
     @tag = Tag.find(params[:id])
    else
      flash[:notice] = 'You need admin privileges to go there.'
      redirect_to :controller => "home", :action => "index"
    end
  end

   # POST /tags
   # POST /tags.json
   def create
     if current_user.try(:admin?)
       @tag = current_user.currentGame().tags.new(params[:tag])
       #Pngqr.encode 
       @tag.user = current_user

       #puts "\n\n\n\n\n\n\n\n\n\n\n\n #{@current_user.currentGame().tags.all.to_s}\n\n\n\n\n\n\n\n\n\n\n"
        if Rails.env.production?
          qrCodeString = "http://" + request.host_with_port + "/tags/" + @tag.uniqueUrl + "/tagFound"

        else
          qrCodeString = "http://" + request.host_with_port + "/tags/" + @tag.uniqueUrl + "/tagFound"
        end


        #Generate the QR code with rqrcode_png
        qr_code_img = RQRCode::QRCode.new(qrCodeString, :size => 10, :level => :h ).to_img
        qr_code_img = qr_code_img.resize(320,320)
        @tag.qr_code = qr_code_img.to_string

       respond_to do |format|
         if @tag.save
           format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
           format.json { render json: @tag, status: :created, location: @tag }
         else
           format.html { render action: "new" }
           format.json { render json: @tag.errors, status: :unprocessable_entity }
         end
       end
     else
       flash[:notice] = 'You need admin privileges to go there.'
       redirect_to :controller => "home", :action => "index"
     end
   end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    if current_user.try(:admin?)
      @tag = Tag.find(params[:id])
      current_user.currentGame().tags << @tag
      @tag.user = current_user
      
      respond_to do |format|
        if @tag.update_attributes(params[:tag])
          format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @tag.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:notice] = 'You need admin privileges to go there.'
      redirect_to :controller => "home", :action => "index"
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    if current_user.try(:admin?)
      @tag = Tag.find(params[:id])
      @tag.destroy

      respond_to do |format|
        format.html { redirect_to tags_url }
        format.json { head :no_content }
      end
    else
      flash[:notice] = 'You need admin privileges to go there.'
      redirect_to :controller => "home", :action => "index"
    end
  end

  def genPDFofTags
    
    tagsLocation = ""
    if Rails.env.production?
      tagsLocation = "http://" + request.host_with_port + "/tags/print"
    else
      tagsLocation = "http://" + request.host_with_port + "/tags/print"
    end

    if (tagsLocation != "")
      kit = PDFKit.new(tagsLocation)

      file = kit.to_file('scanTrakTags.pdf')

      #redirect_to 'scanTrakTags.pdf'

    else
      puts "ERROR ERROR ERROR ERROR TAGSLOCATION EMPTY"
    end


  end


    #PrintTags option
  def printTags
    #if the current user is an admin

      @qrCodes = []
      @tags = current_user.currentGame().tags.paginate(:page => params[:page])
      #@tags = Tag.where(:game_id => current_user.currentGame().id).paginate(:page => params[:page])

      host = request.host_with_port
      @tags.each do |tag|
        if Rails.env.production?
          qrCodeString = "http://" + request.host_with_port + "/tags/" + tag.uniqueUrl + "/tagFound"

        else
          qrCodeString = "http://" + request.host_with_port + "/tags/" + tag.uniqueUrl + "/tagFound"


        end
        @indivQR = RQRCode::QRCode.new(qrCodeString, :size => 10)
        @qrCodes.push(@indivQR)

        #tag.createdByUser = User.find(tag.createdBy).email

      end
      
      respond_to do |format|
        format.html {render :layout => "printable"}# index.html.erb
        format.json { render json: @tags }
      end
  end

  def manualScan
    if user_signed_in?

      if not current_user.currentGame().teams.where(:user_id => current_user.id).empty?
        #user is in a team
        @team = @user.teams.where(:game_id => @user.currentGame().id).first
        render view: "manualScan"
      else
        flash[:alert] = "You are not a member of a team!"
        redirect_to :controller => 'home', :action => 'index'
      end
    else
      #User is not signed in
      flash[:notice] = "Please sign in before scanning a tag"
      redirect_to :controller => 'devise/sessions', :action => 'new'
    end

  end

  def manualScanProcess
    #puts "\n\n\n\n\n\nI GOT HERE\n\n\n\n\n\n\n\n\n"

    @failedScans = Array.new
    @duplicateScans = Array.new
    @successfulScans = Array.new
    @team = Team.find(params[:team_id])
    params.each do |key,value|
      if (splitKey = key.split(" "))[0] == "tagCode"
        tempValue = value.gsub("-","")

        @tag = Tag.where(:uniqueUrl => tempValue).first
        if @tag.nil?
          @failedScans.push(value)
          next
        end

        if @team.tags.where(:uniqueUrl => tempValue).empty?
          @scan = Scan.new
          @scan.save
          @team.scans << @scan
          @tag.scans << @scan
          @successfulScans.push(value)

        else
          @duplicateScans.push(value)
        end





      end
    end

  end

  private

  def handleAdminWithNoGame()
    if user_signed_in?
        if current_user.try(:admin?)
          if current_user.currentGame().nil?
            flash[:alert] = "You can't do anything with tags until you join a game."
            redirect_to new_game_path and return
          end   
        end

    end

  end



end
