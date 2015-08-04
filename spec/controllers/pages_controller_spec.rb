require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe PagesController do
  render_views

    describe "GET #home" do
      it "returns http success" do
        get :home
        expect(response).to have_http_status(:success)
      end
      it "returns title success" do
        get 'home'
        expect(response).to have_title("Simple App du Tutoriel Ruby on Rails | Accueil")
      end
    end

    describe "GET #contact" do
      it "returns http success" do
        get :contact
        expect(response).to have_http_status(:success)
      end
      it "returns title success" do
      get 'contact'
      response.should have_selector("title",
                        :content => "Simple App du Tutoriel Ruby on Rails | Contact")
      end
    end

    describe "GET #about" do
      it "returns http success" do
        get :about
        expect(response).to have_http_status(:success)
      end
      it "returns title success" do
      get 'about'
      response.should have_selector("title",
                        :content => "Simple App du Tutoriel Ruby on Rails | À Propos")
      end
    end

  end
end
