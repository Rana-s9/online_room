class StateCalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  def index
    @room = Room.find(params[:room_id])
    @state_calendars = @room.state_calendars.includes(:user).order(created_at: :desc)
    @state_calendar = current_user.state_calendars.new
    @calendar_users = @state_calendars.includes(:user).map(&:user).uniq
  end

  def new
    @room = Room.find(params[:room_id])
    @state_calendar = current_user.state_calendars.new
    @state_calendar.room = @room
    @state_calendar.date = params[:date] || Date.current
  end

  def create
    @room = Room.find(params[:room_id])
    @state_calendar = current_user.state_calendars.new(state_calendar_params)
    @state_calendar.room = @room

    if @state_calendar.save
        respond_to do |format|
          format.html { redirect_to room_state_calendars_path(@room), notice: "心身コンディションを保存しました" }
          format.json { render json: { id: @state_calendar.id }, status: :created }
        end
    else
        respond_to do |format|
          format.html do
            flash.now[:alert] = "心身コンディションの保存に失敗しました"
            @state_calendars = @room.state_calendars.order(created_at: :desc)
            render :new, status: :unprocessable_entity
          end
          format.json { render json: @state_calendar.errors.full_messages, status: :unprocessable_entity }
        end
    end
  end

  private

  def set_room
    @room = current_user.rooms.find_by(id: params[:room_id])
    unless @room
      redirect_to root_path, alert: "部屋が見つかりませんでした。"
    end
  end

  def state_calendar_params
    params.require(:state_calendar).permit(:mental_state, :physical_state, :date)
  end
end
