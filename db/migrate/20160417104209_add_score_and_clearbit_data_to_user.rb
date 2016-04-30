class AddScoreAndClearbitDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :score, :integer
    add_column :users, :clearbit_data, :jsonb

    add_index :presences, expression: "date_trunc('day', created_at) DESC", name: 'presences_creation_day_index'
  end
end
