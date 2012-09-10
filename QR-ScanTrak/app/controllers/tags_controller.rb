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
      @tags = Tag.all

      host = request.host_with_port

      @tags.each do |tag|
        qrCodeString = "http://" + host.to_s + "/tags/" + tag.uniqueUrl
        @indivQR = RQRCode::QRCode.new(qrCodeString, :size => 7)
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

      qrCodeString = "http://" + request.host_with_port + "/tags/" + @tag.uniqueUrl
      @indivQR = RQRCode::QRCode.new(qrCodeString, :size => 7)

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @tag }
      end

  end

  #Question page

  def tagFound
    @tag = Tag.where(:uniqueUrl => params[:id]).first

  end

  def tagFoundQuizAnswered
    @tag = Tag.where(:uniqueUrl => params[:id]).first
    if (params[:answer].trim == @tag.quizAnswer)
      #add to score
    else

    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    if current_user.try(:admin?)
      @tag = Tag.new
      #@tag.unique = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
      @tag.uniqueUrl = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join


      #Check for uniqueness in the tag url.
      while (!Tag.where(:uniqueUrl => @tag.uniqueUrl).empty?)
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
