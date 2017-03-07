class Relationship < ActiveRecord::Base
 
	belongs_to :follower, :class_name => "User"#On rajoute :class_name => "User" car on a pas de modele follower ou followeds
  belongs_to :followed, :class_name => "User"

  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
 
end
