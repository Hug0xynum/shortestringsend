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
	end
end
