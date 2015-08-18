require 'rails_helper'
require 'spec_helper'

RSpec.describe MicropostsController,"-", type: :controller do
  render_views

  describe "[Access Control]:" do
   #=================================================================
    it "should refuse access to create" do
      post :create
      expect(response).to redirect_to(signin_path)
    end

    it "should refuse access to destroy" do
      delete :destroy, :id => 1
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "[POST 'create']:" do
   #=================================================================
    before(:each) do
      @user = test_sign_in(FactoryGirl.create(:user))
    end

    describe "<FAILED>" do
     #----------------------------------------------------------------
      before(:each) do
        @attr = { :content => "" }
      end

      it "shouldnt create micropost" do
        expect{post :create, :micropost => @attr}.not_to change(Micropost, :count)
      end

      it "should return home page" do
        post :create, :micropost => @attr
        expect(response).to render_template('pages/home')
      end
    end

    describe "<SUCCESS>" do
     #----------------------------------------------------------------
      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end

      it "should create a micropost" do
        expect{post :create, :micropost => @attr}.to change(Micropost, :count).by(1)
      end

      it "should redirect to home page" do
        post :create, :micropost => @attr
        expect(response).to redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :micropost => @attr
        expect(flash[:success]).to match /publié/i
      end
    end
  end
  describe "[DELETE 'destroy']:" do
   #=================================================================
    describe "(Message not write by current_user)" do
     #----------------------------------------------------------------
      before(:each) do
        @user = FactoryGirl.create(:user)
        wrong_user = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
        test_sign_in(wrong_user)
        @micropost = FactoryGirl.create(:micropost, :user => @user)
      end

      it "should refuse destroy action" do
        delete :destroy, :id => @micropost
        expect(response).to redirect_to(root_path)
      end
    end

		describe "(Message write by current_user)" do
		 #----------------------------------------------------------------
      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        @micropost = FactoryGirl.create(:micropost, :user => @user)
      end

      it "should destroy micropost" do
        expect {delete :destroy, :id => @micropost}.to change(Micropost, :count).by(-1)
      end
    end
  end
end