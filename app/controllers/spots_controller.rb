class SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  def index
    @room = Room.find(params[:room_id])
    @spots = @room.spots.includes(:user).order(created_at: :desc)
    @visited = @spots.visited
    @wanna_visit = @spots.wanna_visit
  end

  def new
    @room = Room.find(params[:room_id])
    @spot = Spot.new
  end

  def create
    @room = Room.find(params[:room_id])
    @spot = @room.spots.new(spot_params)
    @spot.user = current_user

    if @spot.save
        redirect_to room_spots_path(@room), notice: "場所を登録しました"
    else
        redirect_to new_room_greeting_path(@room), alert: "場所の登録に失敗しました"
    end
  end

  def show
    @spot = Spot.find(params[:id])
  end

  private

  def set_room
    @room = Room.find_by(id: params[:room_id])
    unless @room && (@room.user_id == current_user.id || RoommateList.exists?(user_id: current_user.id, room_id: @room.id))
      redirect_to root_path, alert: "部屋が見つかりませんでした。"
    end
  end

  def spot_params
    params.require(:spot).permit(:name, :visit_status, :address, :latitude, :longitude, :room_id, :user_id)
  end
end
