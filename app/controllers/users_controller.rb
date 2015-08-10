class UsersController < ApplicationController
  def new
  	@user = User.new
  	@titre = "Inscription"
  end

  def show
    @user = User.find(params[:id])
    @titre = @user.nom
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Bienvenue sur SSS!"
      redirect_to @user
    else
      flash[:error] = "Oups! Votre inscription n'a pas pu se réaliser!"
      @titre = "Inscription"
      render 'new'
      #redirect_to('/signup/error')
      #redirect_to signup_path, :flash => { :error => "<%= render 'shared/error_messages' %>" }
    end
  end

  def user_params
  	# Nécessaire pour pouvoir exécuter l'équivalent de @user = User.new(params[:user]) 
    params.require(:user).permit(:nom, :email, :password,:password_confirmation)#, :salt,:encrypted_password
  end
end
