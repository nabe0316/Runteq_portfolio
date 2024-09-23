class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

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
    redirect_to home_path, notice: 'メッセージと対応する葉が削除されました。'
  end

  def autocomplete
    @q = current_user.messages.ransack(title_or_content_cont: params[:q])
    @messages = @q.result(distinct: true).limit(10)
    render layout: false
  end

  private

  def set_message
    @message = current_user.messages.find_by(id: params[:id])
    unless @message
      flash[:alert] = "このメッセージは存在しません。"
      redirect_to home_path
    end
  end

  def authorize_user
    unless @message.user == current_user
      flash[:alert] = "このメッセージを編集する権限がありません。"
      redirect_to home_path
    end
  end

  def message_params
    params.require(:message).permit(:title, :content)
  end
end
