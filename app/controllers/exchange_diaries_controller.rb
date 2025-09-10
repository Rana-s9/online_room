class ExchangeDiariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  before_action :set_exchange_diary, only: %i[update]
  before_action :mark_unread_diaries_as_read, only: [ :index ]

  def index
    @room = Room.find(params[:room_id])
    @exchange_diaries = @room.exchange_diaries.includes(:user, :reads).order(created_at: :desc).page(params[:page])
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
          format.html { redirect_to room_exchange_diaries_path(@room), notice: t("flash.diary.save") }
          format.json { render json: { id: @exchange_diary.id }, status: :created }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t("flash.diary.failed_save")
            @exchange_diaries = @room.exchange_diaries.order(created_at: :desc).page(params[:page])
            @diary_count = @exchange_diaries.count
            @diary_order = @room.exchange_diaries.order(:created_at).pluck(:id)
            @roommates = current_user.grouped_shared_users[@room.id] || []
            render :index, status: :unprocessable_entity
          end
          format.json { render json: @exchange_diary.errors.full_messages, status: :unprocessable_entity }
        end
      end
  end

  respond_to :html, :json
  def update
    if @exchange_diary.update(exchange_diary_params)
      render json: { message: t("flash.diary.update") }, status: :ok
    else
      render json: { errors: @exchange_diary.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @exchange_diary = @room.exchange_diaries.find_by(user: current_user, id: params[:id])

    if @exchange_diary.destroy
      redirect_to room_exchange_diaries_path(@room), notice: t("flash.diary.delete")
    else
      @exchange_diaries = @room.exchange_diaries.includes(:user).order(created_at: :desc)
      flash.now[:alert] = t("flash.diary.failed_delete")
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find_by(id: params[:room_id])
    unless @room && (@room.user_id == current_user.id || RoommateList.exists?(user_id: current_user.id, room_id: @room.id))
      redirect_to root_path, alert: t("flash.room.failed_find")
    end
  end

  def set_exchange_diary
    @exchange_diary = @room.exchange_diaries.find_by(id: params[:id], user: current_user)
    unless @exchange_diary
      render json: { error: "Not Found" }, status: :not_found
    end
  end

  def mark_unread_diaries_as_read
    # 自分以外の日記で、かつ現在のページに表示される日記のIDを取得
    other_diary_ids = @room.exchange_diaries
                           .where.not(user: current_user)
                           .includes(:reads)
                           .page(params[:page])
                           .pluck(:id)

    return if other_diary_ids.empty?

    # 既に既読済みの日記IDを取得
    already_read_ids = Read.where(
      user: current_user,
      exchange_diary_id: other_diary_ids
    ).pluck(:exchange_diary_id)

    # 未読の日記IDを計算
    unread_diary_ids = other_diary_ids - already_read_ids
    return if unread_diary_ids.empty?

    # バルクインサートで一括作成
    read_records = unread_diary_ids.map do |diary_id|
      {
        user_id: current_user.id,
        exchange_diary_id: diary_id,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    Read.insert_all(read_records)
  end


  def exchange_diary_params
    params.require(:exchange_diary).permit(:body, :user_id, :room_id)
  end
end
