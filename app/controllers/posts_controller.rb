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
      redirect_to posts_path, notice: t("flash.post.create")
    else
      flash.now[alert] = t("flash.post.failed_create")
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
      redirect_to posts_path, notice: t("flash.post.update")
    else
      flash.now[alert] = t("flash.post.failed_update")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find_by(user: current_user, id: params[:id])
    if @post.destroy
      redirect_to posts_path, notice: t("flash.post.delete")
    else
      flash.now[alert] = t("flash.post.failed_delete")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:relationship, :custom_relationship, :post_type, :situation, :custom_situation, :content, :display_name, :custom_name)
  end
end
