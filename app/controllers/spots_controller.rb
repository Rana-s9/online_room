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
        redirect_to room_spots_path(@room), notice: t("flash.spot.save")
    else
        flash.now[:alert] = t("flash.spot.failed_save")
        render :new, status: :unprocessable_entity
    end
  end

  def show
    @room = Room.find(params[:room_id])
    @spot = Spot.find(params[:id])
    @comments = @spot.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end

  def edit
    @room = Room.find(params[:room_id])
    @spot = @room.spots.find_by(user: current_user, id: params[:id])
    @comments = @spot.comments.includes(:user)
    @comment = Comment.new
  end

  def update
    @room = Room.find(params[:room_id])
    @spot = @room.spots.find_by(user: current_user, id: params[:id])

    if @spot.update(spot_params)
      redirect_to room_spots_path(@room), notice: t("flash.spot.update")
    else
      @spots = @room.spots.includes(:user).order(created_at: :desc)
      flash.now[:alert] = t("flash.spot.failed_update")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @spot = @room.spots.find_by(user: current_user, id: params[:id])

    if @spot.destroy
      redirect_to room_spots_path(@room), notice: t("flash.spot.delete")
    else
      @spots = @room.spots.includes(:user).order(created_at: :desc)
      flash.now[:alert] = t("flash.spot.failed_delete")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find_by(id: params[:room_id])
    unless @room && (@room.user_id == current_user.id || RoommateList.exists?(user_id: current_user.id, room_id: @room.id))
      redirect_to root_path, alert: t("flash.room.failed_find")
    end
  end

  def spot_params
    params.require(:spot).permit(:name, :visit_status, :address, :latitude, :longitude, :room_id, :user_id, :date)
  end
end
