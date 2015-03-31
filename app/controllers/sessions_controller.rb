class SessionsController < Devise::SessionsController
  def create
    super

    if resource.is_a?(User)
      resource.update_attributes(:status => "signed_in")
    end
  end
end