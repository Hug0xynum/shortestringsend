require 'rails_helper'
require 'spec_helper'

RSpec.describe Micropost,"Model -", type: :model do

	describe "<SUCCESS>" do

	  	before(:each) do
    		@user = FactoryGirl.create(:user)
    		@attr = { :content => "Micropost's content" }
  		end

		it "should create a new micropost" do
			@user.microposts.create!(@attr)
		end
  
		describe "[Link with User]:" do
		 #================================================================
		  before(:each) do
		    @micropost = @user.microposts.create(@attr)
		  end

	    it "should have a user attribute" do
	      expect(@micropost).to respond_to(:user)
	    end

	    it "should have good linked user" do
	      expect(@micropost.user_id).to eq @user.id
	      expect(@micropost.user).to eq @user
	    end
	  end

	  describe "[Validation]:" do
	   #================================================================
	    it "need an identifiant" do
	      expect(Micropost.new(@attr)).not_to be_valid
	    end

	    it "need a no nil content" do
	      expect(@user.microposts.build(:content => "  ")).not_to be_valid
	    end

	    it "should refuse a too long micropost" do
	      expect(@user.microposts.build(:content => "a" * 141)).not_to be_valid
	    end
	  end
	
		describe "[from_users_followed_by Method]:" do
		 #================================================================
	    before(:each) do
	      @other_user = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
	      @third_user = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))

	      @user_post  = @user.microposts.create!(:content => "foo")
	      @other_post = @other_user.microposts.create!(:content => "bar")
	      @third_post = @third_user.microposts.create!(:content => "baz")

	      @user.follow!(@other_user)
	    end

	    it "should have a class method '.from_users_followed_by'" do
	      expect(Micropost).to respond_to(:from_users_followed_by)
	    end

	    it "should include following's microposts" do
	      expect(Micropost.from_users_followed_by(@user)).to include(@other_post)
	    end

	    it "should include user's microposts" do
	      expect(Micropost.from_users_followed_by(@user)).to include(@user_post)
	    end

	    it "shouldn't include unfollowing's microposts" do
	      expect(Micropost.from_users_followed_by(@user)).not_to include(@third_post)
	    end
	  end
	 end
end
