class AddPhotoScoreToUser < ActiveRecord::Migration
  def change
    add_column :users, :photo_score, :integer
  end
end
