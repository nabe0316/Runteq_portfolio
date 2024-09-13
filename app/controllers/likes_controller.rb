class LikesController < ApplicationController
  before_action :set_message
  before_action :authenticate_user!

  def create
    @like = @message.likes.build(user: current_user)
    if @like.save
      create_notification(@message, @like)
      redirect_back(fallback_location: root_path, notice: 'いいねしました')
    else
      redirect_back(fallback_location: root_path, alert: 'いいねできませんでした')
    end
  end

  def destroy
    @like = @message.likes.find_by(user: current_user)
    if @like&.destroy
      redirect_back(fallback_location: root_path, notice: 'いいねを取り消しました')
    else
      redirect_back(fallback_location: root_path, alert: 'いいねの取り消しができませんでした')
    end
  end

  private

  def set_message
    @message = Message.find(params[:message_id])
  end

  def create_notification(message, like)
    return if message.user == current_user
    Notification.create(
      recipient: message.user,
      actor: current_user,
      action: 'liked',
      notifiable: like
      )
  end
end
