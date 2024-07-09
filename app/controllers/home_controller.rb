class HomeController < ApplicationController
  def index
    if user_signed_in?
      @tree = current_user.tree || current_user.create_tree!
      @messages = current_user.messages || []
      @tree.grow if @tree.svg_data.blank?
    end
  end
end
