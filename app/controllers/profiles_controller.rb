class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :edit, :update]
  before_action :set_user_profile, only: [:show, :edit, :update]

  def show
    @tree = @user.tree
    @messages_count = @user.messages.count
  end

  def edit
  end

  def update
    @profile = current_user.profile
    if @profile.update(profile_params)
      redirect_to @profile, notice: 'プロフィールが更新されました。'
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def set_user_profile
    @user = User.find(params[:id])
    @profile = @user.profile
  end

  def profile_params
    params.require(:profile).permit(:avatar)
  end

  def user_params
    params.require(:user).permit(:avatar)
  end

  def authorize_user
    unless @profile.user == current_user
      flash[:alert] = "アクセス権限がありません。"
      redirect_to root_path
    end
  end
end
