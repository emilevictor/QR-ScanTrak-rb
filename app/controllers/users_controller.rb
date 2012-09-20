class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
      if current_user.try(:admin?)

        #Paginate users

        @users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page])

      else
        flash[:notice] = "You must be an admin to do that."
        redirect_to root_path
      end    

  end

  def create
    @user = User.new(params[:user])

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    if current_user.try(:admin?)
      @user = User.find(params[:id])

      respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @user }
      end

    end
  end

  def edit
    if current_user.try(:admin?)
      @user = User.find(params[:id])
      respond_to do |format|
        format.html #edit.html.erb
      end
    end
  end

  def update
    if current_user.try(:admin?)
      @user = User.find(params[:id])

      respond_to do |format|
        #if the password has been changed, recompute it.
        #if params[:user][:password] != @user.password
        # # params[:user][:password] = BCrypt::Password.create(params[:user][:password])
        #end

        if @user.update_attributes(params[:user])
          #format.html { redirect_to @user, notice: 'User was successfully updated.' }
          #format.json { head :no_content }
          format.html { redirect_to @user, notice: 'Player was successfully updated.' }
          format.json { head :no_content }
        else
          #format.html { redirect_to @user, alert: 'Error: user not successfully updated.' }
          #format.json { render json: @user.errors, status: :unprocessable_entity }
          flash[:alert] = "There was an error while updating the player. Notify an administrator."
          redirect_to :controller => 'users', :action => 'show', :id => @user.id
        end
      end
    end
  end



  private
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "email"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end