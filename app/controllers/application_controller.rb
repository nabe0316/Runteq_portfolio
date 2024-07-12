class ApplicationController < ActionController::Base
  helper_method :show_footer?
  add_flash_types :info, :error, :warning
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    home_path
  end

  def after_sign_up_path_for(resource)
    home_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def show_footer?
    controller_name == 'static_pages' ||
    (controller_name == 'registrations' && action_name == 'new') ||
    (controller_name == 'sessions' && action_name == 'new') ||
    controller_name == 'passwords'
  end
end
