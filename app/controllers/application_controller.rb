class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    home_path
  end

  def after_sign_up_path_for(resource)
    home_path
  end
end
