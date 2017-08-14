class ApplicationController < ActionController::Base  
  # Prevent CSRF attacks by raising an exception. 
  # For APIs, you may want to use :null_session instead. 
  protect_from_forgery with: :exception

  layout :get_layout?

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation,:name,:role,:status, :first_name, :last_name, :address, :location, :country) }
    end

  def  after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
      user_homes_path
    elsif resource_or_scope.is_a?(Admin)
      admin_homes_path
    else
      homes_path
    end
  end

  def  after_sign_up_path_for(resource_or_scope)
    # if resource_or_scope.is_a?(User)
    #   user_homes_path
    if resource_or_scope.is_a?(Admin)
      admin_homes_path
    else
      homes_path
    end
  end

  def  after_sign_out_path_for(resource_or_scope) 
    homes_path
  end

  private
  def is_login?
    unless current_admin || current_user
      redirect_to '/'
    end
  end

  def get_layout?
    if params[:controller] == "admin/homes"
      return "admin"
    else
      return "application"
    end
  end

end
