class CalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room

  def index
  end

  def new
    @room = Room.find(params[:room_id])
    @calendar = current_user.calendars.find_by(room: @room, start_time: params[:start_time]) || current_user.calendars.new(room: @room, start_time: params[:start_time] || Date.current)
  end

  def create
    @calendar = current_user.calendars.new(calendar_params)
    @calendar.room = @room

    if @calendar.save
      redirect_to room_calendars_path(@room), notice: "予定を作成しました"
    else
      flash.now[:alert] = t("flash.state_calendar.failed_save")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def destroy
  end

  private

  def set_room
    @room = Room.find_by(id: params[:room_id])
    unless @room && (@room.user_id == current_user.id || RoommateList.exists?(user_id: current_user.id, room_id: @room.id))
      redirect_to root_path, alert: t("flash.room.failed_find")
    end
  end

  def calendar_params
    params.require(:calendar).permit(:name, :description, :schedule_type, :start_time, :end_time, :visibility, :category, :source, :user_id, :room_id)
  end
end
