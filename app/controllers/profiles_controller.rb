class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_profile, only: [:edit, :update]
  before_action :set_user_profile, only: [:show]

  def show
    @tree = @user.tree
    @messages_count = @user.messages.count
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path(@profile), notice: 'プロフィールが更新されました。'
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
    params.require(:profile).permit(:username)
  end

  def user_params
    params.require(:user).permit(:avatar)
  end
end
