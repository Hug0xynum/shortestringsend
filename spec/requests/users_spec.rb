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
	          		fill_in "Password", :with => ""
	          		fill_in "Confirmation", :with => ""
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
	          		fill_in "Password", :with => "foobar";
	          		fill_in "Confirmation", :with => "foobar";
	          		click_button "Inscription";
	          		expect(response).to render_template('users/new');
	        	end).to change(User, :count).by(1)
	      	end
    	end
  	end
end
