class Post < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'PostAuthorizer'
end
