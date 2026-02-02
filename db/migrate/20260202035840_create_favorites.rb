class CreateFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      #ユニーク制約→同じユーザーが同じ本を2回いいねできない
      t.index [:user_id, :book_id], unique: true

      t.timestamps
    end
  end
end
