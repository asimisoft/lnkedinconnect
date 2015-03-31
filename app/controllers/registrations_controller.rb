class RegistrationsController < Devise::RegistrationsController  
  def create
    super

    if resource.is_a?(User)
      resource.update_attributes(:status => "registered")
    end
  end
end