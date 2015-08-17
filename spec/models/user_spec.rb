require 'rails_helper'
require 'spec_helper'

RSpec.describe User,"Model -", type: :model do
  before(:each) do
    	@attr = { 
    		:nom => "Example User",
    		:email => "user@example.com",
    		:password => "azerty123",
    		:password_confirmation => "azerty123"
    		}
 	end
  describe "<FAILURE>" do
   #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    it "should create a new instance" do
      User.create(@attr)
    end

    describe "[User Object]:" do
     #================================================================
      it "user has an empty name" do
        bad_guy = User.new(@attr.merge(:nom => ""))
        expect(bad_guy).not_to be_valid
      end 

    	it "user has an empty mail" do
    	  bad_guy = User.new(@attr.merge(:email => ""))
    	  expect(bad_guy).not_to be_valid
    	end

    	it "user has name too long" do
    	  long_nom = "a" * 51
    	  long_nom_user = User.new(@attr.merge(:nom => long_nom))
    	  expect(long_nom_user).not_to be_valid
    	end
    	  
    	it "should accept valid mail address" do
    	  adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    	  adresses.each do |address|
    	    valid_email_user = User.new(@attr.merge(:email => address))
    	    expect(valid_email_user).to be_valid
    	  end
    	end

      it "shouldn't accept invalid mail address" do
        adresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        adresses.each do |address|
        	invalid_email_user = User.new(@attr.merge(:email => address))
        	expect(invalid_email_user).not_to be_valid
        end
      end

      it "shouldn't accept unique mail adress twice" do
        # Place un utilisateur avec un email donné dans la BD.
        User.create!(@attr)
        user_with_duplicate_email = User.new(@attr)
        expect(user_with_duplicate_email).not_to be_valid
      end
    end

    describe "[Password validations]:" do
     #================================================================
      it "password needed" do
        secure_user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
        expect(secure_user).not_to be_valid
      end

      it "password's confirmation needed" do
        very_secure_user =User.new(@attr.merge(:password_confirmation => "invalid"))
        expect(very_secure_user).not_to be_valid
      end

      it "has password too short" do
        short = "a" * 5
        hash = @attr.merge(:password => short, :password_confirmation => short)
        expect(User.new(hash)).not_to be_valid
      end

      it "has password too long" do
        long = "a" * 41
        hash = @attr.merge(:password => long, :password_confirmation => long)
        expect(User.new(hash)).not_to be_valid
      end
    end

    describe "[Password encryption]:" do
     #================================================================
      before(:each) do
        @user = User.create!(@attr)
      end

      it "should have an attribute 'encrypted_password' " do
       	expect(@user).to respond_to(:encrypted_password)
      end

      it "is an empty encrypted_password" do
        expect(@user.encrypted_password).not_to be_blank
      end

      describe "(Method has_password?)" do
       #--------------------------------------------------------------
        it "should return true if password are the same" do
          expect(@user.has_password?(@attr[:password])).to be true
       	end    

        it "should return false if password are different" do
          expect(@user.has_password?("invalide")).to be false
        end 
      end
    end

    describe "[Authenticate method]:" do
     #================================================================
      before(:each) do
        @user = User.create!(@attr)
      end

      it "should return nil if password and mail don't match" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        expect(wrong_password_user).to be_nil
      end

      it "should return nil if mail doesn't exist in db" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        expect(nonexistent_user).to be_nil
      end

      it "should return user if password and mail match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        expect(matching_user).to eq @user
      end
    end

    describe "[Attribut admin]" do
     #================================================================
      before(:each) do
        @user = User.create!(@attr)
      end

      it "should confirm admin existence" do
        expect(@user).to respond_to(:admin)
      end

      it "shouldn't be admin by default" do
        expect(@user).not_to be_admin
      end

      it "should become admin" do
        @user.toggle!(:admin)
        expect(@user).to be_admin
      end
    end
  end
end