class RoommateListsController < ApplicationController
  before_action :authenticate_user!

  def join
    token = InvitationToken.find_by(token: params[:token])
    if token.nil?
        redirect_to root_path, alert: t("flash.roommate.no_invite_link")
        return
    end

    if token.expires_at < Time.current
        redirect_to root_path, alert: t("flash.roommate.invite_expired")
        return
    end

    if token.used_at.present?
        redirect_to root_path, alert: t("flash.roommate.invite_used")
        return
    end

    if RoommateList.exists?(user_id: current_user.id, room_id: token.room_id)
      redirect_to root_path, alert: t("flash.roommate.already_joined")
      return
    end

    unless RoommateList.exists?(user_id: current_user.id, room_id: token.room_id)
        RoommateList.create!(user_id: current_user.id, room_id: token.room_id)
    end

    unless RoommateList.exists?(user_id: token.user_id, room_id: token.room_id)
        RoommateList.create!(user_id: token.user_id, room_id: token.room_id)
    end

    token.update!(used_at: Time.current, invited_user: current_user.id)

    redirect_to room_path(token.room_id), notice: t("flash.roommate.joined")
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def authorize_room_access!
    unless @room.user_id == current_user.id || RoommateList.exists?(user_id: current_user.id, room_id: @room.id)
      redirect_to root_path, alert: t("flash.rooms.none_access")
    end
  end
end
