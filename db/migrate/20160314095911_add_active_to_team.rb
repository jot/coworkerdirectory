class AddActiveToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :is_active, :boolean, :null => false, :default => true
  end
end
