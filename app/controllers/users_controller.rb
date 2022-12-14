class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show,:destroy]
  before_action :require_user, except: [:show, :index,:create ,:new]
  before_action :require_same_user, only: [:edit, :update,:destroy]
  

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page:5)
  end

  def index
    @users = User.paginate(page: params[:page], per_page:5)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Dear #{@user.username}, Welcome to alpha blog"
      redirect_to articles_path
    else
      render "new"
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "updated successfully"
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end

   def destroy 
    @user.destroy
    session[:user_id]=nil if @user==current_user
    flash[:notice]="#{@user.username}'s account and articles are deleted"
    redirect_to articles_path
   end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    if (current_user != @user && !current_user.admin?)
      flash[:alert]="only #{@user.username} can edit his profile"
      redirect_to @user
    end
  end

  
end
