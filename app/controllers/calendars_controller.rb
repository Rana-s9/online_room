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

    together_calendars = @room.calendars.includes(:user)
                             .where(visibility: :together)
                             .order(created_at: :desc)

    case params[:visibility]
    when "personal"
      @calendars = personal_calendars
    when "together"
      @calendars = together_calendars
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
      redirect_to root_path, alert: t("flash.calendar.unauthorize")
    end
  end

  def new
    @room = Room.find(params[:room_id])
    start_time = (params[:date].presence && Date.parse(params[:date])) || Date.current
    @calendar = current_user.calendars.find_by(room: @room, start_time: start_time) ||
            current_user.calendars.new(room: @room, start_time: start_time)
  end

  def create
    @calendar = current_user.calendars.new(calendar_params)
    @calendar.room = @room

    if @calendar.save
      redirect_to room_calendars_path(@room), notice: t("flash.calendar.save")
    else
      flash.now[:alert] = t("flash.calendar.failed_save")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @room = Room.find(params[:room_id])
    @calendar = @room.calendars.find(params[:id])
    @calendar_date = params[:date].present? ? Date.parse(params[:date]) : Date.today

    @calendars = @room.calendars
                    .where(user: current_user)
                    .where(start_time: @calendar_date.beginning_of_day..@calendar_date.end_of_day)
  end

  def update
    @room = Room.find(params[:room_id])
    @calendar = @room.calendars.find_by(user: current_user, id: params[:id])

    unless @calendar&.user == current_user
      redirect_to room_calendars_path(@room), alert: t("flash.calendar.unauthorize_update")
    end

    if @calendar.update(calendar_params)
      redirect_to room_calendars_path(@room), notice: t("flash.calendar.update")
    else
      @calendars = @room.calendars.includes(:user).order(created_at: :desc)
      flash.now[:alert] = t("flash.calendar.failed_update")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @calendar = @room.calendars.find_by(user: current_user, id: params[:id])

    unless @calendar&.user == current_user
      redirect_to room_calendars_path(@room), alert: t("flash.calendar.unauthorize_destroy")
    end

    if @calendar.destroy
      redirect_to room_calendars_path(@room), notice: t("flash.calendar.destroy")
    else
      @calendars = @room.calendars.includes(:user).order(created_at: :desc)
      flash.now[:alert] = t("flash.calendar.failed_destroy")
      render :new, status: :unprocessable_entity
    end
  end

  def import
    @room = Room.find(params[:room_id])
    service = CalendarService.new(current_user)
    saved_token = current_user.sync_token
    response = service.fetch_events(sync_token: saved_token)

    events = response.items
    next_sync_token = response.next_sync_token
    google_calendar_id = service.calendar_id

  ActiveRecord::Base.transaction do
    events.each do |event|
      start_time = event.start.date_time || Time.zone.parse(event.start.date.to_s)
      end_time = event.end.date_time || Time.zone.parse(event.end.date.to_s) - 1.second
      schedule_type = event.start.date_time.nil? ? :all_day : :timed

      calendar = current_user.calendars.find_or_initialize_by(google_event_id: event.id, room: @room)
      calendar.assign_attributes(
        name: event.summary || "No Title",
        description: event.description,
        start_time: start_time,
        end_time: end_time,
        schedule_type: schedule_type,
        source: :google,
        visibility: :personal,
        category: :event,
        room: @room,
        google_calendar_id: google_calendar_id,
        google_event_id: event.id,
        last_synced_at: Time.current
      )
      calendar.save!
    end
    current_user.update!(sync_token: response.next_sync_token)
  end
    redirect_to room_calendars_path(@room), notice: t("flash.calendar.input")
  rescue => e
    logger.error "Import failed: #{e.message}"
    flash.now[:alert] = t("flash.calendar.failed_input")
    render :index, status: :unprocessable_entity
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
