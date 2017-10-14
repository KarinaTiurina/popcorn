class CommentsController < ApplicationController
  before_action :set_film, only: [:create, :destroy]
  before_action :set_comment, only: [:destroy]

  def create
    @new_comment = @film.comments.build(comment_params)
    @new_comment.user = current_user

    if @new_comment.save
      redirect_to @film, notice: 'Comment created'
    else
      render 'films/show', alert: 'Comment error'
    end
  end


  def destroy
    message = {notice: 'Comment deleted'}

    if current_user_can_edit?(@comment)
      @comment.destroy!
    else
      message = {alert: 'comment delete error'}
    end

    redirect_to @film, message
  end

  private

  def set_film
    @film = Film.find(params[:film_id])
  end

  def set_comment
    @comment = @film.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :user_name)
  end
end
