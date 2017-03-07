require 'rails_helper'
#require 'capybara'

RSpec.describe UsersController,"-", type: :controller do
  
  render_views
  
  describe "[GET 'index]:" do
   #================================================================
    describe "(User no signed in)" do
     #-----------------------------------------------------------------
      it "should deny access" do
        get :index
        expect(response).to redirect_to(signin_path)
        expect(flash[:notice]).to match /identifier/i
      end
    end

    describe "(User signed in)" do
     #-----------------------------------------------------------------
      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user, :email => "user_connect@example.com"))
        second = FactoryGirl.create(:user, :email => "another_user@example.com")
        third  = FactoryGirl.create(:user, :email => "another@example.net")

        @users = [@user, second, third]
      end

      it "should success" do
        get :index
        expect(response).to be_success
      end
    end
  end

	describe "[GET #show]:" do
   #================================================================
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

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
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "should returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "shouldnt access when signed in" do
      test_sign_in(@user)
      get :new
      expect(response).not_to render_template('new')
      expect(response).to redirect_to(user_path(@user))
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
    describe "<FAILED>:" do
     #-----------------------------------------------------------------
      it "shouldn't create user" do
        no_creation = lambda{post :create, :user => @attr}
        expect(no_creation).not_to change(User, :count)
      end

      it "should return 'new' page" do
        post :create, :user => @attr
        expect(response).to render_template('new')
      end
    end


    describe "<SUCCESS>:" do
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

      # it "shouldnt can be possible if signed in" do
      #   @user = FactoryGirl.create(:user, :email => "trytonocreate@example.com")
      #   test_sign_in(@user)
      #   post :create, @user2 = :user => @attr.merge(:email => "testwhynot@example.fr")
      #   expect(@user2).not_to be_signed_in
      # end
    end
  end

  describe "[GET 'edit']:" do
   #================================================================
    before(:each) do
    @user = FactoryGirl.create(:user, :email => "editionuser@example.com")
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
    @user = FactoryGirl.create(:user, :email => "updateuser@example.com")
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
    @user = FactoryGirl.create(:user, :email => "authentification@example.com")
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
        wrong_user = FactoryGirl.create(:user, :email => "zaza@zaza.net")
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

  describe "[DELETE 'destroy']:" do
   #================================================================
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "(Unidentified user)" do
     #-----------------------------------------------------------------
      it "should deny access" do
        delete :destroy, :id => @user
        expect(response).to redirect_to(signin_path)
      end
    end

    describe "(User No Admin)" do
     #-----------------------------------------------------------------
      it "should protect page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        expect(response).to redirect_to(user_path)
      end
    end

    describe "(Admin)" do
     #-----------------------------------------------------------------

      before(:each) do
        @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end

      it "should remove user selected" do
        expect{delete :destroy, :id => @user}.to change(User, :count).by(-1)
      end

      it "should return to index page" do
        delete :destroy, :id => @user
        expect(response).to redirect_to(users_path)
      end

      it "shouldnt remove admin" do
        expect{delete :destroy, :id => @admin}.not_to change(User, :count)
      end
    end
  end

  describe "[Follow Pages]:" do
   #================================================================

    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    describe "(Unidentified user)" do
     #-----------------------------------------------------------------
      it "should protect following" do
        get :following, :id => @user
        expect(response).to redirect_to(signin_path)
      end

      it "should protect following" do
        get :followers, :id => @user
        expect(response).to redirect_to(signin_path)
      end
    end
  end
end
