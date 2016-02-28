class CreatePresences < ActiveRecord::Migration
  def change
    create_table :presences do |t|
      t.integer :team_id
      t.string :team_uid
      t.jsonb :active_ids
      t.jsonb :active_uids
      t.jsonb :away_ids
      t.jsonb :away_uids
      t.jsonb :slack_api_data
      t.datetime :checked_at

      t.timestamps null: false
    end
  end
end
