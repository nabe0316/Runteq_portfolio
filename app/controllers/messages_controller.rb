class MessagesController < ApplicationController
  def new
    @message = current_user.messages.new
  end

  def create
    @message = current_user.messages.new(message_params)
    if @message.save
      current_user.tree.grow
      redirect_to home_path, notice: "メッセージが作成されました。"
    else
      render :new
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  private

  def message_params
    params.require(:message).permit(:title, :content)
  end
end
