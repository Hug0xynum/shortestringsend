require 'rails_helper'

RSpec.describe Relationship,"Model -", type: :model do

  before(:each) do
    @follower = FactoryGirl.create(:user)
    @followed = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))

    @relationship = @follower.relationships.build(:followed_id => @followed.id)
  end

  it "should create a relationship" do
    @relationship.save!
  end

  describe "[Following Method]" do
   #=================================================================
    before(:each) do
      @relationship.save
    end

    it "should have a follower" do
      expect(@relationship).to respond_to(:follower)
    end

    it "should have a good follewer (link)" do
      expect(@relationship.follower).to eq @follower
    end

    it "should have a following" do
      expect(@relationship).to respond_to(:followed)
    end

    it "should have a following (link)" do
      expect(@relationship.followed).to eq @followed
    end
  end

  describe "[Validations]:" do
   #=================================================================
    it "should want follower_id" do
      @relationship.follower_id = nil
      expect(@relationship).not_to be_valid
    end

    it "should want followed_id" do
      @relationship.followed_id = nil
      expect(@relationship).not_to be_valid
    end
  end
  #----------------------------------------------------------------
end
