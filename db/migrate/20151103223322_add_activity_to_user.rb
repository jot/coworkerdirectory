class AddActivityToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_activity_at, :datetime
    add_column :users, :channels, :json
    add_column :users, :emoji, :json
  end
end
