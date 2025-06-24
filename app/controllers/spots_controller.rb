class SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  def index
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
        flash.now[:alert] = "場所の登録に失敗しました"
        render :new, status: :unprocessable_entity
    end
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def edit
    @spot = @room.spots.find_by(user: current_user, id: params[:id])
  end

  def update
    @room = Room.find(params[:room_id])
    @spot = @room.spots.find_by(user: current_user, id: params[:id])

    if @spot.update(spot_params)
      redirect_to room_spots_path(@room), notice: "場所名を更新しました"
    else
      @spots = @room.spots.includes(:user).order(created_at: :desc)
      flash.now[:alert] = "場所名の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @spot = @room.spots.find_by(user: current_user, id: params[:id])

    if @spot.destroy
      redirect_to room_spots_path(@room), notice: "場所を削除しました"
    else
      @spots = @room.spots.includes(:user).order(created_at: :desc)
      flash.now[:alert] = "場所の削除に失敗しました"
      render :new, status: :unprocessable_entity
    end
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
