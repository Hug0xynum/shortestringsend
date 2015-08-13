require 'rails_helper'
#require 'capybara'

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
                :email => "toto@example.com",
                :password => "foobar",
                :password_confirmation => "foobar" }
    end

    it "should create user" do
      creation = lambda{post :create, :user => @attr}
      expect(creation).to change(User, :count).by(1)
    end

    it "should sign in user" do
        post :create, :user => @attr
        expect(controller).to be_signed_in
      end
      
    it "should return 'user' page" do
      post :create, :user => @attr
      expect(response).to redirect_to(user_path(assigns(:user)))
    end

    it "should a welcoming message" do
      post :create, :user => @attr
      expect(flash.now[:success]).to match /Bienvenue sur SSS!/i
    end
  end
  
  describe "[GET 'edit']:" do
   #================================================================
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    it "should success" do
      get :edit, :id => @user
      expect(response).to be_success
    end
  end

  describe "[PUT 'update']:" do
   #================================================================
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    describe "<FAILED>" do
     #-----------------------------------------------------------------
      before(:each) do
        @attr = { :nom => "", :email => "",
                  :password => "", :password_confirmation => "" }
      end

      it "should return edit page" do
        put :update, :id => @user, :user => @attr
        expect(response).to render_template('edit')
      end
    end

    describe "<SUCCESS>" do
     #-----------------------------------------------------------------
      before(:each) do
        @attr = { :nom => "New Name", :email => "user@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz" }
      end

      it "should modify user's fields" do
        put :update, :id => @user, :user => @attr
        @user.reload
        expect(@user.nom).to eq @attr[:nom]
        expect(@user.email).to eq @attr[:email]
      end

      it "should redirect to user profile" do
        put :update, :id => @user, :user => @attr
        expect(response).to redirect_to(user_path(@user))
      end

      it "should show a flash message" do
        put :update, :id => @user, :user => @attr
        expect(flash[:success]).to match /actualisé/
      end
    end
  end

  describe "[Authentification for edit/update]:" do
   #================================================================
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "(User no signed in)" do
     #-----------------------------------------------------------------
      it "should refuse access to edit" do
        get :edit, :id => @user
        expect(response).to redirect_to(signin_path)
      end

      it "should refuse access to update" do
        put :update, :id => @user, :user => {}
        expect(response).to redirect_to(signin_path)
      end
    end

    describe "(User signed in)" do
     #-----------------------------------------------------------------
      before(:each) do
        wrong_user = FactoryGirl.create(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should be user wanted edit" do
        get :edit, :id => @user
        expect(response).to redirect_to(user_path)
      end

      it "should be user wanted update" do
        put :update, :id => @user, :user => {}
        expect(response).to redirect_to(user_path)
      end
    end
  end
end
