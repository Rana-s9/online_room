class ReadsController < ApplicationController
  def create
    @exchange_diary =ExchangeDiary.find(params[:exchange_diary_id])

    if @exchange_diary.use_id == current_user.id
      redirect_to exchange_diaries_path, alert: t("flash.read.self_read")
      return
    end

    current_user.read(@exchange_diary)
    redirect_to exchange_diaries_path, alert: t("flash.read.success")
  end

  def destroy
    @exchange_diary = current_user.reads.find(params[:id]).exchange_diary
    current_user.read(@exchange_diary)
    redirect_to exchange_diaries_path, notice: t("flash.read.failed")
  end
end
