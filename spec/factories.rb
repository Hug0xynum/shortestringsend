# En utilisant le symbole ':user', nous faisons que
# Factory Girl simule un modèle User.
FactoryGirl.define do
	factory :user do |user|
  		user.nom                   "Example User"
  		user.email                 "user@example.com"
  		user.password              "azerty123"
  		user.password_confirmation "azerty123"
  	end

  	#Use to create a new email with the function next in our spec
	sequence :email do |n|
  		"person-#{n}@example.com"
	end
end

