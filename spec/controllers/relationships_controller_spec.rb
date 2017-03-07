require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
	
	describe "[ACCESS CONTROL]:" do
 	 #================================================================
	    it "should needed signin" do
	      post :create
	       expect(response).to redirect_to(signin_path)
	    end

	    it "should needed signin" do
	      delete :destroy, :id => 1
	       expect(response).to redirect_to(signin_path)
	    end
	  end

	describe "[POST 'create']:" do
	 #================================================================
	    before(:each) do
	      @user = test_sign_in(FactoryGirl.create(:user))
	      @followed = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
	    end

	    it "should create a relationship" do
	      expect{
	      	post :create, :relationship => { :followed_id => @followed }
	        expect(response).to be_redirect
	      }.to change(Relationship, :count).by(1)
	    end

	    it "should create a relationship with Ajax" do
	      expect{
	      	xhr :post, :create, :relationship => { :followed_id => @followed }
	        expect(response).to be_success
	      }.to change(Relationship, :count).by(1)
	    end
	  end

  describe "[DELETE 'destroy']:" do
   #================================================================
    before(:each) do
      @user = test_sign_in(FactoryGirl.create(:user))
      @followed = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
      @user.follow!(@followed)
      @relationship = @user.relationships.find_by_followed_id(@followed)
    end

    it "should destroy a relationship" do
      expect{
        delete :destroy, :id => @relationship
        expect(response).to be_redirect
	    }.to change(Relationship, :count).by(-1)
    end

    it "should destroy a relationship with Ajax" do
      expect{
      	xhr :delete, :destroy, :id => @relationship
        expect(response).to be_success
      }.to change(Relationship, :count).by(-1)
    end
  end
end
