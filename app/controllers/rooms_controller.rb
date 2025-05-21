class RoomsController < ApplicationController
  def index
    @room = Room.new
    @rooms = current_user.rooms.includes(:user).order(created_at: :desc)
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
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end
