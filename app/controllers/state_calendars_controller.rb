class StateCalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  def index
    @room = Room.find(params[:room_id])
    @state_calendars = @room.state_calendars.includes(:user).order(created_at: :desc)
    @calendar_users = current_user.grouped_shared_users[@room.id] || []
    @calendars_by_user = @state_calendars.group_by(&:user_id)
    @today_state = current_user.state_calendars.find_by(room: @room, date: Date.current)
  end

  def new
  @room = Room.find(params[:room_id])
  @state_calendar = current_user.state_calendars.find_by(room: @room, date: params[:date]) || current_user.state_calendars.new(room: @room, date: params[:date] || Date.current)
  end

  def create
  @room = Room.find(params[:room_id])
  existing_calendar = current_user.state_calendars.find_by(date: state_calendar_params[:date], room_id: @room.id)

    if existing_calendar
      flash[:alert] = t("flash.state_calendar.exist")
      redirect_to room_state_calendars_path(@room)
    else
      @state_calendar = current_user.state_calendars.new(state_calendar_params)
      @state_calendar.room = @room

      if @state_calendar.save
        redirect_to room_state_calendars_path(@room), notice: t("flash.state_calendar.save")
      else
        flash.now[:alert] = t("flash.state_calendar.failed_save")
        render :new, status: :unprocessable_entity
      end
    end
  end

  def show
    @room = Room.find(params[:room_id])
    @state_calendar = @room.state_calendars.find(params[:id])
  end

  def edit
    @room = Room.find(params[:room_id])
    @state_calendar = @room.state_calendars.find_by(user: current_user, id: params[:id])
    unless @state_calendar&.user == current_user
      redirect_to room_state_calendars_path(@room), alert: t("flash.state_calendar.unauthorize")
    end
  end

  def update
    @room = Room.find(params[:room_id])
    @state_calendar = @room.state_calendars.find_by(user: current_user, id: params[:id])

    unless @state_calendar&.user == current_user
      redirect_to room_state_calendars_path(@room), alert: t("flash.state_calendar.unauthorize")
    end

    if @state_calendar.update(state_calendar_params)
      redirect_to room_state_calendars_path(@room), notice: t("flash.state_calendar.update")
    else
      @state_calendars = @room.state_calendars.includes(:user).order(created_at: :desc)
      flash.now[:alert] = t("flash.state_calendar.failed_update")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @state_calendar = @room.state_calendars.find_by(user: current_user, id: params[:id])

    if @state_calendar.destroy
      redirect_to room_state_calendars_path(@room), notice: t("flash.state_calendar.delete")
    else
      @state_calendars = @room.state_calendars.includes(:user).order(created_at: :desc)
      flash.now[:alert] = t("flash.state_calendar.failed_delete")
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find_by(id: params[:room_id])
    unless @room && (@room.user_id == current_user.id || RoommateList.exists?(user_id: current_user.id, room_id: @room.id))
      redirect_to root_path, alert: t("flash.room.failed_find")
    end
  end

  def state_calendar_params
    params.require(:state_calendar).permit(:mental_state, :physical_state, :date)
  end
end
