class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:destroy]

  def index
    @notifications = current_user.notifications.recent
  end

  def mark_as_read
    @notifications = current_user.notifications.unread
    @notifications.update_all(read_at: Time.zone.now)
    redirect_to notifications_path
  end

  def destroy
    if @notification.destroy
      redirect_to notifications_path, notice: '通知が削除されました。'
    else
      redirect_to notifications_path, alert: '通知の削除に失敗しました。'
    end
  end

  private

  def set_notification
    @notification = current_user.notifications.find_by(id: params[:id])
    unless @notification
      redirect_to notifications_path, alert: '通知が見つかりません。'
    end
  end
end
