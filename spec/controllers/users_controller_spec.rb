require 'rails_helper'
require 'capybara'

RSpec.describe UsersController, type: :controller do
	

	describe "GET 'show'" do

    	before(:each) do
      		@user = FactoryGirl.create(:user)
    	end

    	it "devrait réussir" do
      		get :show, :id => @user
      		expect(response).to be_success
    	end

    	it "devrait trouver le bon utilisateur" do
      		get :show, :id => @user
      		expect(assigns(:user)).to eq @user
    	end
  	end

  	describe "GET #new" do
    	it "returns http success" do
      		get :new
      		expect(response).to have_http_status(:success)
    	end
  	end
end
