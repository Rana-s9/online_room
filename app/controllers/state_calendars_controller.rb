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
      flash[:alert] = "この日付の記録はすでに存在します。カレンダーから選択、更新してください。"
      redirect_to room_state_calendars_path(@room)
    else
      @state_calendar = current_user.state_calendars.new(state_calendar_params)
      @state_calendar.room = @room

      if @state_calendar.save
        redirect_to room_state_calendars_path(@room), notice: "心身コンディションを保存しました"
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    @room = Room.find(params[:room_id])
    @state_calendar = @room.state_calendars.find_by(user: current_user, id: params[:id])
    unless @state_calendar&.user == current_user
      redirect_to room_state_calendars_path(@room), alert: "不正なアクセスです"
    end
  end

  def update
    @room = Room.find(params[:room_id])
    @state_calendar = @room.state_calendars.find_by(user: current_user, id: params[:id])

    unless @state_calendar&.user == current_user
      redirect_to room_state_calendars_path(@room), alert: "不正なアクセスです"
    end

    if @state_calendar.update(state_calendar_params)
      redirect_to room_state_calendars_path(@room), notice: "心身コンディションを更新しました"
    else
      @state_calendars = @room.state_calendars.includes(:user).order(created_at: :desc)
      flash.now[:alert] = "心身コンディションの更新に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @state_calendar = @room.state_calendars.find_by(user: current_user, id: params[:id])

    if @state_calendar.destroy
      redirect_to room_state_calendars_path(@room), notice: "心身コンディションを削除しました"
    else
      @state_calendars = @room.state_calendars.includes(:user).order(created_at: :desc)
      flash.now[:alert] = "心身コンディションの削除に失敗しました"
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find_by(id: params[:room_id])
    unless @room && (@room.user_id == current_user.id || RoommateList.exists?(user_id: current_user.id, room_id: @room.id))
      redirect_to root_path, alert: "部屋が見つかりませんでした。"
    end
  end

  def state_calendar_params
    params.require(:state_calendar).permit(:mental_state, :physical_state, :date)
  end
end
