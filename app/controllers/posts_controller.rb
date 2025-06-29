class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "投稿が作成されました"
    else
      flash.now[alert] = "投稿の作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @answer = Answer.new
    @answers = @post.answers.includes(:user).order(created_at: :desc)
  end

  def edit
    @post = Post.find_by(user: current_user, id: params[:id])
    @answer = Answer.new
    @answers = @post.answers.includes(:user).order(created_at: :desc)
  end

  def update
    @post = Post.find_by(user: current_user, id: params[:id])
    if @post.update(post_params)
      redirect_to posts_path, notice: "投稿を更新しました"
    else
      flash.now[alert] = "投稿の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find_by(user: current_user, id: params[:id])
    if @post.destroy
      redirect_to posts_path, notice: "投稿を削除しました"
    else
      flash.now[alert] = "投稿の削除に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:relationship, :custom_relationship, :post_type, :situation, :custom_situation, :content, :display_name, :custom_name)
  end
end
