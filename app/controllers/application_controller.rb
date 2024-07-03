class ApplicationController < ActionController::Base
  helper_method :show_footer?

  protected

  def after_sign_in_path_for(resource)
    home_path
  end

  def after_sign_up_path_for(resource)
    home_path
  end

  def show_footer?
    controller_name == 'static_pages' ||
    (controller_name == 'registrations' && action_name == 'new') ||
    (controller_name == 'sessions' && action_name == 'new') ||
    controller_name == 'passwords'
  end
end
