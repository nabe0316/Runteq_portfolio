class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.messages.ransack(params[:q])
    @messages = @q.result(distinct: true).order(created_at: :desc)
  end

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
  end

  def edit
  end

  def update
    if @message.update(message_params)
      redirect_to @message, notice: 'メッセージが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @message.destroy
    redirect_to home_path, notice: 'メッセージが削除されました。'
  end

  private

  def set_message
    @message = current_user.messages.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:title, :content)
  end
end
