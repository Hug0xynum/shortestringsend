# En utilisant le symbole ':user', nous faisons que
# Factory Girl simule un modèle User.
FactoryGirl.define do
	factory :user do |user|
  		user.nom                   "Example User"
  		user.email                 "user@example.com"
  		user.password              "azerty123"
  		user.password_confirmation "azerty123"
  	end
end