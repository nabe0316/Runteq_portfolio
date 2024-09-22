class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if user_signed_in?
      @tree = current_user.tree || current_user.create_tree!
      @messages = current_user.messages
      @current_stage = @tree.current_stage
    end

    @recent_messages = Message.recent.includes(:user).limit(10)
  end
end
