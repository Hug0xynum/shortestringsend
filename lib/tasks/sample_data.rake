# require 'faker'

# namespace :db do
#   desc "Create a DB with lot of users for development"
#   task :populate => :environment do
#     Rake::Task['db:reset'].invoke
#     make_users
#     make_microposts
#     make_relationships
#   end
# end

# def make_users
#   admin = User.create!(:nom => "Moderateur",
#                        :email => "azerty@azerty.com",
#                        :password => "azerty",
#                        :password_confirmation => "azerty")
#   admin.toggle!(:admin)
#   99.times do |n|
#     nom  = Faker::Name.name
#     email = "example-#{n+1}@railstutorial.org"
#     password  = "password"
#     User.create!(:nom => nom,
#                  :email => email,
#                  :password => password,
#                  :password_confirmation => password)
#     Rake::Task['db:migrate'].invoke
#   end
# end

# def make_microposts
#   User.limit(6).each do |user|
#     50.times do
#       content = Faker::Lorem.sentence(5)
#       user.microposts.create!(:content => content)
#     end
#   end
# end

# def make_relationships
#   users = User.all
#   user  = users.first
#   following = users[1..50]
#   followers = users[3..40]
#   following.each { |followed| user.follow!(followed) }
#   followers.each { |follower| follower.follow!(user) }
# end