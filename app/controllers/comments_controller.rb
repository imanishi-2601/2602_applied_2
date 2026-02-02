class CommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @comment = @book.comments.new(comment_params)
    @comment.user = Current.session.user

    if @comment.save
      redirect_back fallback_location: book_path(@book), notice: "Comment created!"
    else
      redirect_back fallback_location: book_path(@book), alert: "Comment failed."
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    @comment = @book.comments.find(params[:id])

    @comment.destroy
    redirect_back fallback_location: book_path(@book)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
