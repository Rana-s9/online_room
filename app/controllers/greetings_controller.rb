class GreetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  def index
    @room = Room.find(params[:room_id])
    @greetings = @room.greetings.includes(:user).order(created_at: :desc)
    @welcome = @greetings.welcome.where(user: current_user)
    @return = @greetings.return.where(user: current_user)
    @roommates_except_self = current_user.roommates_except_self(@room)
  end

  def new
    @room = Room.find(params[:room_id])
    @greeting = @room.greetings.new
  end

  def create
    @room = Room.find(params[:room_id])
    @greeting = @room.greetings.new(greeting_params)
    @greeting.user = current_user

    if @greeting.save
        redirect_to room_greetings_path(@room), notice: "メッセージを登録しました"
    else
        flash.now[:alert] = "メッセージの登録に失敗しました"
        render :new, status: :unprocessable_entity
    end
  end

  def update
    @room = Room.find(params[:room_id])
    @greeting = @room.greetings.find_by(user: current_user, id: params[:id])

    if @greeting.update(greeting_params)
      redirect_to room_greetings_path(@room), notice: "メッセージを更新しました"
    else
      @greetings = @room.greetings.includes(:user).order(created_at: :desc)
      flash.now[:alert] = "メッセージの更新に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @room = Room.find(params[:room_id])
    @greeting = @room.greetings.find_by(user: current_user, id: params[:id])
  end

  def destroy
    @room = Room.find(params[:room_id])
    @greeting = @room.greetings.find_by(user: current_user, id: params[:id])

    if @greeting.destroy
      redirect_to room_greetings_path(@room), notice: "メッセージを削除しました"
    else
      @greetings = @room.greetings.includes(:user).order(created_at: :desc)
      flash.now[:alert] = "メッセージの削除に失敗しました"
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

  def greeting_params
    params.require(:greeting).permit(:message, :greeting_type, :room_id, :user_id)
  end
end
