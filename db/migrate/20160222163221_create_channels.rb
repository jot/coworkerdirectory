class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :uid
      t.string :name
      t.datetime :created
      t.string :creator
      t.boolean :is_archived
      t.boolean :is_member
      t.integer :num_members
      t.integer :team_id
      t.jsonb :slack_data
      t.jsonb :properties

      t.timestamps null: false
    end
  end
end
