require 'rails_helper'
require 'spec_helper'

RSpec.describe SessionsController,"-", type: :controller do

	describe "<FAILURE>" do
   #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ <FAILURE>
		render_views

		describe "[GET #new]:" do
		 #================================================================ [GET #new]
    	it "should returns http success" do
      	get :new
      	expect(response).to have_http_status(:success)
    	end
	  end	
  	describe "[POST 'create']:" do
  	 #================================================================ [POST 'create']
	    
	    describe "(Invalid SignIn)" do
	     #----------------------------------------------------------------- (Invalid SignIn)
	      before(:each) do
	        @attr = { :email => "email@example.com",
	        			 		:password => "invalid" }
	      end

	      it "should return signin page" do
	       	post :create, :session => @attr
	       	expect(response).to render_template('new')
	      end

	      it "should return a message flash.now" do
	       	post :create, :session => @attr
	       	expect(flash.now[:error]).to match /invalid/i
	    	end
	    end

	    describe "(Valid SignIn)" do
	     #----------------------------------------------------------------- (Valid SignIn)
	      before(:each) do
        	@user = FactoryGirl.create(:user)
        	@attr = { :email => @user.email,
        						:password => @user.password }
      	end

	      it "should find user" do
	       	post :create, :session => @attr
	       	expect(controller.current_user).to eq @user
        	expect(controller).to be_signed_in
	      end

	      it "should return 'user' page" do
        	post :create, :session => @attr
        	expect(response).to redirect_to(user_path(@user))
      	end
	    end
  	end

		describe "[DELETE 'destroy']:" do
		 #================================================================ [DELETE 'destroy']
		  it "should sign out" do
	      test_sign_in(FactoryGirl.create(:user))
	      delete :destroy
	      expect(controller).not_to be_signed_in
	      expect(response).to redirect_to(root_path)
	    end
	  end

	end
end
