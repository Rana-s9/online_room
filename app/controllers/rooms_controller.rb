require "net/http"
require "uri"
require "json"

class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [ :show ]
  before_action :authorize_room_access!, only: [ :show ]

  def index
    @room = Room.new
    invited_and_own_room
  end

  def create
    if current_user.owned_rooms.count >= 5
      flash[:alert] = t("flash.rooms.5rooms")
      redirect_to rooms_path and return
    end

    @room = current_user.owned_rooms.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: t("flash.rooms.new") }
      else
        invited_and_own_room
        flash.now[:alert] = t("flash.rooms.failed_create")
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @room }
    end
    @whiteboards = @room.whiteboards.includes(:user).order(created_at: :desc)
    @whiteboard = @room.whiteboards.find_or_create_by(user: current_user)
    @roommates = User.joins(:roommate_lists).where(roommate_lists: { room_id: @room.id }).includes(area: :weather_record)

    @state_calendars = @room.state_calendars.includes(:user).order(created_at: :desc)
    @state_calendar = current_user.state_calendars.new
    @calendar_users = @state_calendars.includes(:user).map(&:user).uniq
    @greetings = @room.greetings.includes(:user).order(created_at: :desc)
    @welcome = @greetings.welcome
    @return = @greetings.return

    @my_welcome = @welcome.where(user: current_user)
    @others_welcome = @welcome.where.not(user: current_user)

    @my_return = @return.where(user: current_user)

    @roommates_except_self = current_user.roommates_except_self(@room)

    room_users = current_user.grouped_shared_users[@room.id]
    @calendar = Calendar
              .includes(:user)
              .where(room: @room, visibility: "together", user: room_users)
              .where("start_time >= ?", Date.today)
              .order(:start_time)
              .first

    @welcome_display =
      if @roommates_except_self.any?
        if @others_welcome.any?
          message = @others_welcome.sample
          { message: message.message, user: message.user }
        else
          user = @roommates_except_self.sample
          { message: t("flash.rooms.welcome"), user: user }
        end
      else
        if @my_welcome.any?
          message = @my_welcome.sample
          { message: message.message, user: message.user }
        else
          { message: t("flash.rooms.welcome"), user: current_user }
        end
      end

    @return_display =
      if @my_return.any?
        message = @my_return.sample
        { message: message.message, user: message.user }
      else
        { message: t("flash.rooms.return"), user: current_user }
      end

      if params[:from_home_button]
        users = (current_user.grouped_shared_users[@room.id] || [])
        updated_any = false
        failed_any = false

        users.uniq.each do |user|
          area = user.area
          next unless area

          weather_record = area.weather_record
          if weather_record.nil? || weather_record.updated_at < 30.minutes.ago
            weather_record ||= WeatherRecord.new(area: area)
            if save_weather_record(area, weather_record)
              updated_any = true
            else
              failed_any = true
            end
          end
        end

        if failed_any
          redirect_to root_path, alert: t("views.weather.failed_save") and return
        elsif updated_any
          redirect_to room_path(@room), notice: t("views.weather.update") and return
        else
          flash[:just_signed_in] = t("flash.rooms.back_home")
        end
      end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def invited_and_own_room
    my_rooms = current_user.owned_rooms
    join_rooms = Room.joins(:invitation_tokens).where(invitation_tokens: { invited_user: current_user.id })
    @rooms = (my_rooms + join_rooms).uniq
    @invitation_map = InvitationToken
                      .where(invited_user: current_user, room_id: @rooms.map(&:id))
                      .index_by(&:room_id)
    @rooms = Room.where(id: @rooms.map(&:id)).includes(:user, :roommates)
    @area = current_user.area || current_user.build_area
  end

  def authorize_room_access!
    unless @room.user_id == current_user.id || RoommateList.exists?(user_id: current_user.id, room_id: @room.id)
      redirect_to root_path, alert: t("flash.rooms.none_access")
    end
  end

  def fetch_weather_from_api(city, lang = "ja")
    api_key = ENV["WEATHER_API"]
    url = URI("https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&units=metric&lang=#{lang}")
    response = Net::HTTP.get_response(url)
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      Rails.logger.debug "API (#{lang}) description: #{data['weather'][0]['description']}"
      data
    else
      Rails.logger.error "API request failed: #{response.code} #{response.message}"
      nil
    end
  rescue => e
    Rails.logger.error "Weather API error: #{e.message}"
    nil
  end

  def save_weather_record(area, weather_record)
  ja_data = fetch_weather_from_api(area.city, "ja")
  en_data = fetch_weather_from_api(area.city, "en")

  return false unless ja_data.present? && en_data.present?

  weather_record.assign_attributes(
    temperature: ja_data["main"]["temp"],
    humidity: ja_data["main"]["humidity"],
    description: ja_data["weather"][0]["description"],
    description_en: en_data["weather"][0]["description"],
    temp_min: ja_data["main"]["temp_min"],
    temp_max: ja_data["main"]["temp_max"]
  )

  if weather_record.changed?
      weather_record.save
  else
      weather_record.touch
  end
  end

  def room_params
    params.require(:room).permit(:name)
  end
end
