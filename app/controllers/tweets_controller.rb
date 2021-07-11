class TweetsController < ApplicationController
  before_action :authenticate_user!
  def index
    if params[:search]==nil
      @tweets = Tweet.all.page(params[:page]).per(3)
    elsif params[:search]==" "
      @tweets = Tweet.all.page(params[:page]).per(3)
    else
      @tweets = Tweet.where("body LIKE ?",'%'+params[:search]+'%').page(params[:page]).per(3)
    end
  end

  def new
    @tweets = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params)

    @tweet.user_id = current_user.id
    if @tweet.save
      redirect_to root_path
    else
      render new
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
    @comments = @tweet.comments
    @comment = Comment.new
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    @tweet = Tweet.find(params[:id])
    @tweet.update(tweet_params)
    redirect_to("/")
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_to action: :index
  end

  private
  def tweet_params
    params.require(:tweet).permit(:body, :image)
  end
end
