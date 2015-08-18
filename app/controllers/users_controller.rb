require 'will_paginate/array' 

class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @titre = "Tous les utilisateurs"
    @users = User.all.sort_by{|user| user[:id]}.paginate(page: params[:page], per_page: 30)
    @count = User.count
  end

  def new
    if signed_in?
      flash[:notice] = "Vous êtes déjà identifié."
      redirect_to current_user
    else
  	  @user = User.new
  	  @titre = "Inscription"
    end
  end

  def show
    @user = User.find(params[:id])
    @titre = @user.nom
#>TODO<[TEST A ECRIRE/]
    if !signed_in?
      flash.now[:notice] = "Merci de vous identifier pour voir l'intégralité du contenu"
    else signed_in?
      @microposts = @user.microposts.paginate(:page => params[:page], per_page: 12)
    end
#[/TEST A ECRIRE]
  end

  def create
    # if signed_in?
    #   redirect_to current_user
    # else
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
    # end
  end

  def edit
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

  def destroy
    @user = User.find(params[:id])
    if !current_user?(@user)
      @user.destroy
      flash[:success] = "Utilisateur supprimé."
      redirect_to users_path
    else
      flash[:error] = "Vous ne pouvez pas vous supprimez. Vous pouvez cependant désactiver votre compte."
      redirect_to users_path
    end
  end

  def user_params
  	# Nécessaire pour pouvoir exécuter l'équivalent de @user = User.new(params[:user]) 
    params.require(:user).permit(:nom, :email, :password,:password_confirmation)#, :salt,:encrypted_password
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to user_path unless current_user?(@user)
    end

    def admin_user
      redirect_to user_path unless current_user.admin?
    end
end
