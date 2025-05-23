class ExchangeDiariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room

  def index
    @room = Room.find(params[:room_id])
    @exchange_diaries = @room.exchange_diaries.includes(:user).order(created_at: :desc).page(params[:page])
    @exchange_diary = current_user.exchange_diaries.new
    @diary_count = @exchange_diaries.count
    @diary_order = @room.exchange_diaries.order(:created_at).pluck(:id)
  end

  def create
    @room = Room.find(params[:room_id])
    @exchange_diary = current_user.exchange_diaries.new(exchange_diary_params)
    @exchange_diaries = @room.exchange_diaries.includes(:user).order(created_at: :desc)
    @exchange_diary.room = @room

    if @exchange_diary.save
      redirect_to room_exchange_diaries_path(@room), notice: "日記を保存しました"
    else
      flash.now[:alert] = "日記の保存に失敗しました"
      @exchange_diaries = @room.exchange_diaries.order(created_at: :desc) # index の再表示用に必要

      render :index, status: :unprocessable_entity
    end
  end

  def update
    @room = Room.find(params[:room_id])
    @exchange_diary = @room.exchange_diaries.find_by(user: current_user, id: params[:id])
    
    if @exchange_diary.update(exchange_diary_params)
      redirect_to room_exchange_diaries_path(@room), notice: "日記を更新しました"
    else
      @exchange_diaries = @room.exchange_diaries.includes(:user).order(created_at: :desc)
      flash.now[:alert] = "日記の更新に失敗しました"
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @exchange_diary = @room.exchange_diaries.find_by(user: current_user, id: params[:id])

    if @exchange_diary.destroy
      redirect_to room_exchange_diaries_path(@room), notice: "日記を消しました"
    else
      @exchange_diaries = @room.exchange_diaries.includes(:user).order(created_at: :desc)
      flash.now[:alert] = "日記の削除に失敗しました"
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = current_user.rooms.find_by(id: params[:room_id])
    unless @room
      redirect_to root_path, alert: "部屋が見つかりませんでした。"
    end
  end

  def exchange_diary_params
    params.require(:exchange_diary).permit(:body, :room_id)
  end
end
