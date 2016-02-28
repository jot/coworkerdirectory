class AddUserToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :user_id, :integer
    add_column :teams, :user_uid, :string
  end
end
