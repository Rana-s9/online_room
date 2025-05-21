class ExchangeDiariesController < ApplicationController
  before_action :authenticate_user!

  def index
    @exchange_diaries = ExchangeDiary.includes(:user).order(created_at: :desc).page(params[:page])
    @exchange_diary = current_user.exchange_diaries.new
    # @diaries_rank = ExchangeDiary.order(:created_at).pluck(:id).index(@exchange_diary.id)
    @diary_count = ExchangeDiary.count
  end

  def create
    @exchange_diary = current_user.exchange_diaries.new(exchange_diary_params)

    respond_to do |format|
      if @exchange_diary.save
        format.js
      else
        format.js { render :error }
      end
    end
  end

  private

  def exchange_diary_params
    params.require(:exchange_diary).permit(:body)
  end
end
