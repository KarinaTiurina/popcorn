class CommentsController < ApplicationController
  before_action :set_film, only: [:create, :destroy]
  before_action :set_comment, only: [:destroy]

  def create
    @new_comment = @film.comments.build(comment_params)
    @new_comment.user = current_user

    if @new_comment.save
      redirect_to @film, notice: I18n.t('controllers.comments.created')
    else
      render 'films/show', alert: I18n.t('controllers.comments.error')
    end
  end


  def destroy
    message = {notice: I18n.t('controllers.comments.destroyed')}

    if current_user_can_edit?(@comment)
      @comment.destroy!
    else
      message = {alert: I18n.t('controllers.comments.error')}
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
