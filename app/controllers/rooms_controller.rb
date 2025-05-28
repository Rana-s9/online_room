class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [ :show ]
  before_action :authorize_room_access!, only: [ :show ]

  def index
    @room = Room.new
    my_rooms = current_user.rooms
    join_rooms = Room.joins(:invitation_tokens).where(invitation_tokens: { invited_user: current_user.id })
    @rooms = (my_rooms + join_rooms).uniq
    @invitation_map = InvitationToken
                      .where(invited_user: current_user, room_id: @rooms.map(&:id))
                      .index_by(&:room_id)
    @rooms = Room.where(id: @rooms.map(&:id)).includes(:user, :roommates)
    @area = current_user.area || current_user.build_area
  end

  def create
    if current_user.rooms.count >= 5
      flash[:alert] = "1人あたり5部屋まで登録できます。"
      redirect_to rooms_path and return
    end

    @room= current_user.rooms.new(room_params)
    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: "部屋を作成しました" }
      else
        format.html { render :index, alert: "部屋を作成できませんでした", status: :unprocessable_entity }
      end
    end
  end

  def show
    @room = Room.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @room } # JSONが来たらJSONで返す
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
  end

  private

  def set_room
    @room = Room.find(params[:id])
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
