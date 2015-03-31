class Article < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'ArticleAuthorizer'
end