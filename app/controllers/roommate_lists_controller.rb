class RoommateListsController < ApplicationController
  before_action :authenticate_user!

  def join
    token = InvitationToken.find_by(token: params[:token])
    if token.nil?
        redirect_to root_path, alert: "招待リンクが存在しません"
        return
    end

    if token.expires_at < Time.current
        redirect_to root_path, alert: "招待リンクの有効期限が切れています"
        return
    end

    if token.used_at.present?
        redirect_to root_path, alert: "この招待リンクはすでに使用されています"
        return
    end

    if RoommateList.exists?(user_id: current_user.id, room_id: token.room_id)
      redirect_to root_path, alert: "すでにこのルームに参加しています"
      return
    end

    unless RoommateList.exists?(user_id: current_user.id, room_id: token.room_id)
        RoommateList.create!(user_id: current_user.id, room_id: token.room_id)
    end

    unless RoommateList.exists?(user_id: token.user_id, room_id: token.room_id)
        RoommateList.create!(user_id: token.user_id, room_id: token.room_id)
    end

    token.update!(used_at: Time.current, invited_user: current_user.id)

    redirect_to room_path(token.room_id), notice: "ルームに参加しました"
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
end
