class FavoritesController < ApplicationController
def create
  book = Book.find(params[:book_id])
  Current.session.user.favorites.find_or_create_by!(book: book)

  redirect_back fallback_location: books_path, notice: "いいねしました"
end
def destroy
  book = Book.find(params[:book_id])
  favorite = Current.session.user.favorites.find_by(book: book)
  favorite&.destroy

  redirect_back fallback_location: books_path, notice: "いいねを解除しました"
end
end