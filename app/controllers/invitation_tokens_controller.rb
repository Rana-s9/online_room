class InvitationTokensController < ApplicationController
  before_action :set_room
  before_action :authenticate_user!

  def index
    @room = Room.find(params[:room_id])
    if @room.user_id == current_user.id
        @invitation_tokens = @room.invitation_tokens.distinct.order(created_at: :desc)
    else
        redirect_to root_path, alert: t("flash.invitation.view")
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
      redirect_to room_invitation_tokens_path(@room), notice: t("flash.invitation.generated")
    else
      redirect_to root_path, alert: t("flash.invitation.failed_generate")
    end
  end

  def update
    @room = Room.find(params[:room_id])
    token = InvitationToken.find(params[:id])
    if token.used_at.present?
        redirect_to invitation_tokens_path, alert: t("flash.invitation.already_used")
        return
    end

    if @room.user_id == current_user.id
        redirect_to invitation_tokens_path(@room), alert: t("flash.invitation.cannot_use")
        return
    end

    if token.expires_at.present? && token.expires_at < Time.current
        redirect_to invitation_tokens_path, alert: t("flash.invitation.expired")
        return
    end

    token.update!(
        used_at: Time.current,
        invited_user: current_user.id
    )

    redirect_to root_path, notice: t("flash.invitation.used")
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def authorize_room_access!
    unless @room.user_id == current_user.id || RoommatesList.exists?(user_id: current_user.id, room_id: @room.id)
      redirect_to root_path, alert: t("flash.rooms.none_access")
    end
  end

  def invitation_token_params
    params.require(:invitation_token).permit(:token)
  end
end
