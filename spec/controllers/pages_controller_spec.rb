require 'rails_helper'

RSpec.describe PagesController,"-", type: :controller do

  describe "<FAILURE>" do
   #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    render_views

    describe "[GET #home]:" do
     #================================================================
      it "should returns http success" do
        get :home
        expect(response).to have_http_status(:success)
      end
    end

    describe "[GET #contact]:" do
     #================================================================
      it "should returns http success" do
        get :contact
        expect(response).to have_http_status(:success)
      end
    end

    describe "[GET #about]:" do
     #================================================================
      it "should returns http success" do
        get :about
        expect(response).to have_http_status(:success)
      end
    end

    describe "[GET #help]:" do
     #================================================================
      it "should returns http success" do
        get :help
        expect(response).to have_http_status(:success)
      end
    end
  end
end
