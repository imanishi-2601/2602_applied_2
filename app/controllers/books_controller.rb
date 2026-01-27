class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :require_owner!, only: [:edit, :update, :destroy]

  def index
    @user  = Current.session.user
    @book  = Book.new
    @books = Book.includes(:user).all
  end

  def create
    @book = Book.new(book_params)
    @book.user = Current.session.user

    if @book.save
      redirect_to book_path(@book), notice: "Book was successfully created."
    else
      @user  = Current.session.user
      @books = Book.includes(:user).all
      render :index, status: :unprocessable_entity
    end
  end

  def show
    # @book は set_book で取得済み

    # 左側「User info」
    @user = @book.user

    # 左側「New book」フォーム（空のフォーム用）
    @new_book = Book.new
  end

  def edit
    # @book は set_book で取得済み
  end

  def update
    # @book は set_book で取得済み
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "Book was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # @book は set_book で取得済み
    @book.destroy
    redirect_to books_path, notice: "Book deleted!", status: :see_other
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def require_owner!
    return if @book.user == current_user

    redirect_to books_path, alert: "権限がありません", status: :see_other
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end
end