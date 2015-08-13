class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  def new
  	@user = User.new
  	@titre = "Inscription"
  end

  def show
    @user = User.find(params[:id])
    @titre = @user.nom
    #[TEST A ECRIRE/]
    unless signed_in?
      flash.now[:notice] = "Merci de vous identifier pour voir l'intégralité du contenu"
    end
    #[/TEST A ECRIRE]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Bienvenue sur SSS!"
      redirect_to @user
    else
      flash.now[:error] = "Oups! Votre inscription n'a pas pu se réaliser!"
      @titre = "Inscription"
      render 'new'
      #redirect_to('/signup/error')
      #redirect_to signup_path, :flash => { :error => "<%= render 'shared/error_messages' %>" }
    end
  end

  def edit
    #@user = User.find(params[:id])
    @titre = "Édition du profil"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profil actualisé."
      redirect_to @user
    else
      @titre = "Édition profil"
      render 'edit'
    end
  end

  def user_params
  	# Nécessaire pour pouvoir exécuter l'équivalent de @user = User.new(params[:user]) 
    params.require(:user).permit(:nom, :email, :password,:password_confirmation)#, :salt,:encrypted_password
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(user_path) unless current_user?(@user)
    end
end
