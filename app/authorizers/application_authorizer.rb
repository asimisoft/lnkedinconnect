# Other authorizers should subclass this one
class ApplicationAuthorizer < Authority::Authorizer
  def self.default(adjective, user)
    false
  end
end