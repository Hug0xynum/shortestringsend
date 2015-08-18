require 'rails_helper'
require 'spec_helper'

RSpec.describe "Microposts", type: :request do
  describe "GET /microposts" do
    it "works! (now write some real specs)" do
      get microposts_index_path
      expect(response).to have_http_status(200)
    end
  end

# describe "Microposts" do

#   before(:each) do
#     user = Factory(:user)
#     visit signin_path
#     fill_in :email,    :with => user.email
#     fill_in :password, :with => user.password
#     click_button
#   end

#   describe "création" do

#     describe "échec" do

#       it "ne devrait pas créer un nouveau micro-message" do
#         lambda do
#           visit root_path
#           fill_in :micropost_content, :with => ""
#           click_button
#           response.should render_template('pages/home')
#           response.should have_selector("div#error_explanation")
#         end.should_not change(Micropost, :count)
#       end
#     end

#     describe "succès" do

#       it "devrait créer un nouveau micro-message" do
#         content = "Lorem ipsum dolor sit amet"
#         lambda do
#           visit root_path
#           fill_in :micropost_content, :with => content
#           click_button
#           response.should have_selector("span.content", :content => content)
#         end.should change(Micropost, :count).by(1)
#       end
#     end
#   end
# end

end
