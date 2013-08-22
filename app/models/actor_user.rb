class ActorUser < ActiveRecord::Base
  self.table_name = 'actors_users'

  belongs_to :user
  belongs_to :actor

end
