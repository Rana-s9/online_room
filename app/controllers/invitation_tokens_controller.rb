class InvitationTokensController < ApplicationController
  before_action :set_room
  before_action :authenticate_user!

  def index
    @room = Room.find(params[:room_id])
    if @room.user_id == current_user.id
        @invitation_tokens = @room.invitation_tokens.distinct.order(created_at: :desc)
    else
        redirect_to root_path, alert: "自分が作成した部屋のトークンしか表示できません"
        return
    end
    @valid_tokens = @invitation_tokens.select { |token| token.used_at.nil? && token.expires_at > Time.current }
  end

  def create
    @room = Room.find(params[:room_id])
    if @room.user_id == current_user.id
      InvitationToken.create!(
          room: @room,
          user: current_user,
          token: SecureRandom.hex(16),
          expires_at: 30.minutes.from_now
        )
      redirect_to room_invitation_tokens_path(@room), notice: "トークンを発行しました"
    else
      redirect_to root_path, alert: "トークンの発行に失敗しました"
    end
  end

  def update
    @room = Room.find(params[:room_id])
    token = InvitationToken.find(params[:id])
    # すでに使われていれば何もしない
    if token.used_at.present?
        redirect_to invitation_tokens_path, alert: "このトークンはすでに使用されています"
        return
    end

    if @room.user_id == current_user.id
        redirect_to invitation_tokens_path(@room), alert: "部屋の作成者はトークンを使用できません"
        return
    end

    # トークンの有効期限チェック（必要なら）
    if token.expires_at.present? && token.expires_at < Time.current
        redirect_to invitation_tokens_path, alert: "このトークンは期限切れです"
        return
    end

    # トークン使用記録
    token.update!(
        used_at: Time.current,
        invited_user: current_user.id
    )

    redirect_to root_path, notice: "トークンを使用しました"
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def authorize_room_access!
    unless @room.user_id == current_user.id || RoommatesList.exists?(user_id: current_user.id, room_id: @room.id)
      redirect_to root_path, alert: "この部屋にアクセスできません"
    end
  end

  def invitation_token_params
    params.require(:invitation_token).permit(:token)
  end
end
