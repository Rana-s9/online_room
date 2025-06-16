class ExchangeDiariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  before_action :set_exchange_diary, only: %i[update]

  def index
    @room = Room.find(params[:room_id])
    @exchange_diaries = @room.exchange_diaries.includes(:user).order(created_at: :desc).page(params[:page])
    @exchange_diary = current_user.exchange_diaries.new
    @diary_count = @exchange_diaries.count
    @diary_order = @room.exchange_diaries.order(:created_at).pluck(:id)
    @roommates = current_user.grouped_shared_users[@room.id] || []

    respond_to do |format|
      format.html
      format.json { render json: @exchange_diaries }
    end
  end

  def create
    @room = Room.find(params[:room_id])
    @exchange_diary = current_user.exchange_diaries.new(exchange_diary_params)
    @exchange_diary.room = @room

      if @exchange_diary.save
        respond_to do |format|
          format.html { redirect_to room_exchange_diaries_path(@room), notice: "日記を保存しました" }
          format.json { render json: { id: @exchange_diary.id }, status: :created }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = "日記の保存に失敗しました"
            @exchange_diaries = @room.exchange_diaries.order(created_at: :desc)
            render :index, status: :unprocessable_entity
          end
          format.json { render json: @exchange_diary.errors.full_messages, status: :unprocessable_entity }
        end
      end
  end

  respond_to :html, :json
  def update
    if @exchange_diary.update(exchange_diary_params)
      render json: { message: "更新成功" }, status: :ok
    else
      render json: { errors: @exchange_diary.errors.full_messages }, status: :unprocessable_entity
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
    @room = Room.find_by(id: params[:room_id])
    unless @room && (@room.user_id == current_user.id || RoommateList.exists?(user_id: current_user.id, room_id: @room.id))
      redirect_to root_path, alert: "部屋が見つかりませんでした。"
    end
  end

  def set_exchange_diary
    @exchange_diary = @room.exchange_diaries.find_by(id: params[:id], user: current_user)
    unless @exchange_diary
      render json: { error: "Not Found" }, status: :not_found
    end
  end


  def exchange_diary_params
    params.require(:exchange_diary).permit(:body, :user_id, :room_id)
  end
end
