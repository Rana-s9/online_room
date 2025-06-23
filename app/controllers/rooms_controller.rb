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
      flash[:alert] = "1人あたり5部屋まで作成できます。"
      redirect_to rooms_path and return
    end

    @room = current_user.owned_rooms.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: "部屋を作成しました" }
      else
        invited_and_own_room
        flash.now[:alert] = "部屋を作成できませんでした"
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

    @welcome_display =
      if @roommates_except_self.any?
        if @others_welcome.any?
          message = @others_welcome.sample
          { message: message.message, user: message.user }
        else
          user = @roommates_except_self.sample
          { message: "おかえりなさい！", user: user }
        end
      else
        if @my_welcome.any?
          message = @my_welcome.sample
          { message: message.message, user: message.user }
        else
          { message: "おかえりなさい！", user: current_user }
        end
      end

    @return_display =
      if @my_return.any?
        message = @my_return.sample
        { message: message.message, user: message.user }
      else
        { message: "ただいま！", user: current_user }
      end

      if params[:from_home_button]
        flash[:just_signed_in] = "帰宅しました"
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
      redirect_to root_path, alert: "この部屋にアクセスできません"
    end
  end

  def room_params
    params.require(:room).permit(:name)
  end
end
