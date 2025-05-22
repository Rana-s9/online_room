class WhiteboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room

  def create
    @whiteboard = @room.whiteboards.build(whiteboard_params)
    @whiteboard.user = current_user
    if current_user.whiteboards.where(room_id: @room.id).exists?
      flash[:alert] = "1人あたり伝言は1枠です。"
      redirect_to room_path(@room) and return
    end

    if @whiteboard.save
      redirect_to room_path(@room), notice: "ホワイトボードに伝言を残しました。"
    else
      @whiteboards = @room.whiteboards.order(created_at: :desc)           # 再表示用
      flash.now[:alert] = "ホワイトボードの伝言更新に失敗しました。"
      render "rooms/show"
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def whiteboard_params
    params.require(:whiteboard).permit(:body, :room_id)
  end
end
