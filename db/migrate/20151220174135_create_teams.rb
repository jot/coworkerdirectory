class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :uid
      t.string :domain
      t.string :email_domain
      t.string :bot_user_id
      t.string :bot_access_token
      t.json :slack_data

      t.timestamps null: false
    end
  end
end
