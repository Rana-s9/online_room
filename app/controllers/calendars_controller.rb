class CalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room

  def index
    @room = Room.find(params[:room_id])
    @calendars = @room.calendars.includes(:user).order(created_at: :desc)
    @calendar_users = current_user.grouped_shared_users[@room.id] || []
    @today_state = current_user.state_calendars.find_by(room: @room, date: Date.current)

    shared_calendars = @room.calendars.includes(:user).where(visibility: [ :share_only, :together ]).order(created_at: :desc)

    personal_calendars = @room.calendars.includes(:user)
                                    .where(visibility: :personal, user: current_user)
                                    .order(created_at: :desc)

    if params[:visibility] == "personal"
      @calendars = personal_calendars
    else
      if params[:category].present? && Calendar.categories.key?(params[:category])
        category_value = Calendar.categories[params[:category]]
        @calendars = shared_calendars.where(category: category_value)
      else
        @calendars = shared_calendars
      end
    end
  end

  def show
    @room = Room.find(params[:room_id])
    @calendar = @room.calendars.includes(:user).find(params[:id])

    if @calendar.visibility == "personal" && @calendar.user != current_user
      redirect_to root_path, alert: "この予定を見る権限がありません。"
    end
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
    @room = Room.find(params[:room_id])
    @calendars = @room.calendars.find(params[:id])
    @calendar_date = params[:date].present? ? Date.parse(params[:date]) : Date.today

    @calendars = @room.calendars
                    .where(user: current_user)
                    .where(start_time: @calendar_date.beginning_of_day..@calendar_date.end_of_day)
  end

  def update
    @room = Room.find(params[:room_id])
    @calendar = @room.calendars.find_by(user: current_user, id: params[:id])

    unless @calendar&.user == current_user
      redirect_to room_calendars_path(@room), alert: t("flash.state_calendar.unauthorize")
    end

    if @calendar.update(calendar_params)
      redirect_to room_calendars_path(@room), notice: t("flash.state_calendar.update")
    else
      @calendars = @room.calendars.includes(:user).order(created_at: :desc)
      flash.now[:alert] = t("flash.state_calendar.failed_update")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @calendar = @room.calendars.find_by(user: current_user, id: params[:id])

    unless @calendar&.user == current_user
      redirect_to room_calendars_path(@room), alert: t("flash.state_calendar.unauthorize")
    end

    if @calendar.destroy
      redirect_to room_calendars_path(@room), notice: t("flash.state_calendar.update")
    else
      @calendars = @room.calendars.includes(:user).order(created_at: :desc)
      flash.now[:alert] = t("flash.state_calendar.failed_update")
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

  def calendar_params
    params.require(:calendar).permit(:name, :description, :schedule_type, :start_time, :end_time, :visibility, :category, :source, :user_id, :room_id)
  end
end
