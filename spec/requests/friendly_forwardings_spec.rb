=begin
require 'spec_helper'
require 'rails_helper'

RSpec.describe "FriendlyForwardings Request -", type: :request do
	describe "FriendlyForwardings" do

	  it "devrait rediriger vers la page voulue après identification" do
	    user = FactoryGirl.create(:user)
	    visit edit_user_path(user)
	    # Le test suit automatiquement la redirection vers la page d'identification.
	    fill_in :email,    :with => user.email
	    fill_in :password, :with => user.password
	    click_button "S'identifier"
	    # Le test suit à nouveau la redirection, cette fois vers users/edit.
	    expect(response).to render_template('users/edit')
	  end
	end
end
=end
