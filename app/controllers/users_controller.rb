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
    @user = User.find(params[:id])

    respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
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