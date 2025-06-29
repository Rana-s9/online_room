class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  def create
    @answer = current_user.answers.build(answer_params)
    @post = @answer.post
    if @answer.save
      redirect_to post_path(@post), notice: "コメントが作成されました"
    else
      flash.now[alert] = "コメントの作成に失敗しました"
      @answers = @post.answers.includes(:user)
      render "posts/show", status: :unprocessable_entity
    end
  end

  def update
    @answer = current_user.answers.find(params[:id])
    @post = @answer.post
    if @answer.update
      redirect_to post_path(@post), notice: "コメントが更新されました"
    else
      flash.now[alert] = "コメントの更新に失敗しました"
      @answers = @post.answers.includes(:user)
      render "posts/show", status: :unprocessable_entity
    end
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @post = @answer.post
    if @answer.destroy
      redirect_to post_path(@post), notice: "コメントが削除されました"
    else
      flash.now[alert] = "コメントの削除に失敗しました"
      @answers = @post.answers.includes(:user)
      render "posts/show", status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body).merge(post_id: params[:post_id])
  end
end
