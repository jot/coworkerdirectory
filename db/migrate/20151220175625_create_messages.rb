class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :channel_uid
      t.integer :channel_id
      t.string :team_uid
      t.integer :team_id
      t.text :text
      t.string :ts
      t.datetime :timestamp
      t.string :message_type
      t.string :message_subtype
      t.string :user_uid
      t.integer :user_id
      t.json :properties
      t.json :slack_data

      t.timestamps null: false
    end
  end
end
