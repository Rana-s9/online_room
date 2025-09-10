class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  def create
    @comment = current_user.comments.build(comment_params)
    @spot = @comment.spot
    @room = @spot.room
    if @comment.save
      redirect_to room_spot_path(@spot.room, @spot), notice: t("flash.spot.comment.new")
    else
      flash.now[:alert] = t("flash.spot.comment.failed_create")
      @comments = @spot.comments.includes(:user)
      render "spots/show", status: :unprocessable_entity
    end
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @spot = @comment.spot
    if @comment.update
      redirect_to room_spot_path(@spot.room, @spot), notice: t("flash.spot.comment.update")
    else
      flash.now[:alert] = t("flash.spot.comment.failed_update")
      @comments = @spot.comments.includes(:user)
      render "spots/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @spot = @comment.spot
    if @comment.destroy
      redirect_to room_spot_path(@spot.room, @spot), notice: t("flash.spot.comment.delete")
    else
      flash.now[:alert] = t("flash.spot.comment.failed_delete")
      @comments = @spot.comments.includes(:user)
      render "spots/show", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(spot_id: params[:spot_id])
  end
end
