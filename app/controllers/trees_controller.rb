class TreesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tree

  def edit
  end

  def update
    if @tree.update(tree_params)
      @tree.grow
      redirect_to home_path, notice: '木のカスタマイズが成功しました。'
    else
      render :edit
    end
  end

  def preview
  end

  def set_tree
    @tree = current_user.tree
  end

  def tree_params
    params.require(:tree).permit(:leaf_color, :leaf_shape)
  end
end
