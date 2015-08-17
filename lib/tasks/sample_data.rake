require 'faker'

namespace :db do
  desc "Create a DB with lot of users for development"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    administrateur = User.create!(:nom => "Moderateur",
                                  :email => "azerty@azerty.com",
                                  :password => "azerty987654",
                                  :password_confirmation => "azerty987654")
    administrateur.toggle!(:admin)
    99.times do |n|
      nom  = Faker::Name.name
      email = "user#{n+1}@db.test"
      password  = "azerty"
      User.create!(:nom => nom,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
      Rake::Task['db:migrate'].invoke
    end
  end
end