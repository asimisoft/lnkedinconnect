class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :authenticate_user!
  
  def all
    user = User.from_omniauth(env["omniauth.auth"], current_user)
    
    p "*************************"
    p user
    p "*************************"
    if user.persisted?
      flash[:notice] = "You are in..!!! Go to edit profile"
      sign_in_and_redirect(user)
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to "/"
    end
  end

  def failure
    super
  end

  alias_method :linkedin, :all
  alias_method :passthru, :all
  alias_method :facebook, :all
end
