class AddSlackDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :slack_auth_data, :json
    add_column :users, :slack_api_data, :json
    add_column :users, :slack_reactions_data, :json
    add_column :users, :slack_auth_data_updated_at, :datetime
    add_column :users, :slack_api_data_updated_at, :datetime
    add_column :users, :slack_reactions_data_updated_at, :datetime
    add_column :users, :team_uid, :string
    add_column :users, :team_name, :string
    add_column :users, :team_domain, :string
  end
end
