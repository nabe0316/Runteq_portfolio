class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.recent
  end

  def mark_as_read
    @notifications = current_user.notifications.unread
    @notifications.update_all(read_at: Time.zone.now)
    redirect_to notifications_path
  end
end
