require 'rails_helper'
require 'spec_helper'


RSpec.describe "Users Request -", type: :request do
  
  	describe "[Sign Up]:" do

	    describe "<FAILED>" do
	      	it "shouldn't create user" do
	        	expect(lambda do
	          		visit signup_path
	          		fill_in "Nom", :with => ""
	          		fill_in "Email", :with => ""
	          		fill_in "Mot de Passe", :with => ""
	          		fill_in "Confirmation du Mot de Passe", :with => ""
	          		click_button "Inscription"
	          		expect(response).to render_template('users/new')
	        	end).not_to change(User, :count)
	      	end
    	end

    	describe "<SUCCESS>" do
	      	it "should create user" do
	        	expect(lambda do
	        		visit signup_path;
	          		fill_in "Nom", :with => "Example User";
	          		fill_in "Email", :with => "user@example.com";
	          		fill_in "Mot de Passe", :with => "foobar";
	          		fill_in "Confirmation du Mot de Passe", :with => "foobar";
	          		click_button "Inscription";
	          		expect(response).to render_template('users/new');
	        	end).to change(User, :count).by(1)
	      	end
    	end
  	end

  	describe "[Sign In]:" do

	    describe "<FAILED>" do
	      	it "shouldnt identify user" do
		        visit signin_path
		        fill_in "Email", :with => ""
		        fill_in "Mot de passe", :with => ""
		        click_button "S'identifier"
		        #response.should has_selector?("div.flash.error", :content => "Invalid")
		        expect(response).to render_template('sessions/new');
	      	end
	    end

	    #describe "<SUCCESS>" do
	    #  	it "should identify user and after sign out" do
		#        user = FactoryGirl.create(:user)
		#        visit signin_path
		#        fill_in "Email", :with => user.email
		#        fill_in "Mot de passe", :with => user.password
	  	#		click_button "S'identifier"
	  	#        expect(controller).to be_signed_in
		#        click_link "Déconnexion"
		#        expect(controller).not_to be_signed_in
	    #	end
		#end
  	end
end
