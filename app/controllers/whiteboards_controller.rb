class WhiteboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  before_action :set_whiteboard, only: %i[update]

  def create
    @whiteboard = @room.whiteboards.find_or_initialize_by(user: current_user)
    if @whiteboard.update(whiteboard_params)
      render json: { id: @whiteboard.id }, status: :ok
    else
      render json: { errors: @whiteboard.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @whiteboard.update(whiteboard_params)
      head :ok
    else
      render json: { errors: @whiteboard.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_whiteboard
    @whiteboard = @room.whiteboards.find_by(user: current_user)
    render json: { error: "Not Found" }, status: :not_found unless @whiteboard
  end

  def whiteboard_params
    params.require(:whiteboard).permit(:body, :room_id)
  end
end
