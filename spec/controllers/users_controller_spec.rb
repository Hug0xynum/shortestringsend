require 'rails_helper'
require 'capybara'

RSpec.describe UsersController,"-", type: :controller do

	describe "<FAILURE>" do
   #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

  	describe "[GET #show]:" do
     #================================================================
    	it "should success" do
      		get :show, :id => @user
      		expect(response).to be_success
    	end

    	it "should find user" do
      		get :show, :id => @user
      		expect(assigns(:user)).to eq @user
    	end
    end

    describe "[GET #new]:" do
     #================================================================
      it "should returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "[POST 'create']:" do
   #================================================================
    before(:each) do
      @attr = { :nom => "", 
                :email => "",
                :password => "",
                :password_confirmation => "" }
    end

    it "shouldn't create user" do
      no_creation = lambda{post :create, :user => @attr}
      expect(no_creation).not_to change(User, :count)
    end

    it "should return 'new' page" do
      post :create, :user => @attr
      expect(response).to render_template('new')
    end
  end

  describe "[POST 'create' - success]:" do
   #-----------------------------------------------------------------
    before(:each) do
      @attr = { :nom => "New User",
                :email => "tototototo@example.com",
                :password => "foobar",
                :password_confirmation => "foobar" }
    end

    it "should create user" do
      creation = lambda{post :create, :user => @attr}
      expect(creation).to change(User, :count).by(1)
    end
      
    it "should return 'user' page" do
      post :create, :user => @attr
      expect(response).to redirect_to(user_path(assigns(:user)))
    end

    it "should a welcoming message" do
      post :create, :user => @attr
      expect(flash[:success]) =~ /Bienvenue dans l'Application Exemple/i
    end
  end
end
