require 'rubygems'
require 'rqrcode'


class TagsController < ApplicationController
  #before_filter :authenticate_admin!
  # GET /tags
  # GET /tags.json
  #include 'Pngqr'

  def index
    if current_user.try(:admin?)
      @qrCodes = []
      @tags = Tag.paginate(:page => params[:page])

      host = request.host_with_port
      @tags.each do |tag|
        if Rails.env.production?
          qrCodeString = "http://" + request.host_with_port + "/qrscantrak/tags/" + tag.uniqueUrl + "/tagFound"

        else
          qrCodeString = "http://" + request.host_with_port + "/tags/" + tag.uniqueUrl + "/tagFound"


        end
        @indivQR = RQRCode::QRCode.new(qrCodeString, :size => 8)
        @qrCodes.push(@indivQR)

        #tag.createdByUser = User.find(tag.createdBy).email

      end
      
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
      @tag = Tag.where(:uniqueUrl => params[:id]).first
      if not @tag.nil?


        if Rails.env.production?
          qrCodeString = "http://" + request.host_with_port + "/qrscantrak/tags/" + tag.uniqueUrl + "/tagFound"

        else
          qrCodeString = "http://" + request.host_with_port + "/tags/" + @tag.uniqueUrl + "/tagFound"
        end
        @indivQR = RQRCode::QRCode.new(qrCodeString, :size => 8)

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
      @numberOfTeams = Scan.where(:tag_id => @tag.id).count
      respond_to do |format|
        format.html
        format.json {render tag: @tag, numberOfTeams: @numberOfTeams}
      end
    else
      redirect_to :controller => "devise/sessions", :action => "create"
    end
  end

  def tagFoundQuizAnswered

    if user_signed_in?
      #Check that the user hasn't scanned this yet.
      @user = User.find(current_user.id)
      #Team of the current user.
      @team = Team.find(@user.team_id)

      @tag = Tag.where(:uniqueUrl => params[:id]).first

      #Check that tag hasn't been scanned yet.
      if !Scan.where(:team_id => @team.id, :tag_id => @tag).first.nil?
        
        if (params[:answer] == @tag.quizAnswer) or (@tag.quizQuestion.empty?)
          #cool... They got the answer correct or there was no question.
          #Now we can create a scan,
          #add it to their team.



          @scan = Scan.new
          
          @scan.save

          @team.scans << @scan

          @tag.scans << @scan


          flash[:notice] = "You successfully scanned the tag"
          redirect_to :controller => "teams", :action => "checkTeamScore"

        else
          flash[:alert] = "You got the answer wrong!"
          redirect_to :controller => "tags", :action => "tagFound", :id => @tag.uniqueUrl
        end

      elsif current_user.admin?
        if (params[:answer] == @tag.quizAnswer) or (@tag.quizQuestion.empty?)
          #cool... They got the answer correct or there was no question.
          #Now we can create a scan,
          #add it to their team.



          @scan = Scan.new
          
          @scan.save

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
      redirect_to sign_in_path
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
      @tag.uniqueUrl = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join


      #Check for uniqueness in the tag url.

      while (!Tag.where(:uniqueUrl => @tag.uniqueUrl).first.nil?)
        @tag.uniqueUrl = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
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
      @tag = Tag.new(params[:tag])
      @tag.user_id = current_user.id
      #Pngqr.encode 

      respond_to do |format|
        if @tag.save
          current_user.tags << @tag
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



end
