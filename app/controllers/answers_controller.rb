class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  def create
    @answer = current_user.answers.build(answer_params)
    @post = @answer.post
    if @answer.save
      redirect_to post_path(@post), notice: t("flash.post.comment.new")
    else
      flash.now[alert] = t("flash.post.comment.failed_create")
      @answers = @post.answers.includes(:user)
      render "posts/show", status: :unprocessable_entity
    end
  end

  def update
    @answer = current_user.answers.find(params[:id])
    @post = @answer.post
    if @answer.update
      redirect_to post_path(@post), notice: t("flash.post.comment.update")
    else
      flash.now[alert] = t("flash.post.comment.failed_update")
      @answers = @post.answers.includes(:user)
      render "posts/show", status: :unprocessable_entity
    end
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @post = @answer.post
    if @answer.destroy
      redirect_to post_path(@post), notice: t("flash.post.comment.delete")
    else
      flash.now[alert] = t("flash.post.comment.failed_delete")
      @answers = @post.answers.includes(:user)
      render "posts/show", status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body).merge(post_id: params[:post_id])
  end
end
