class AddWelcomeMessagesToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin_welcome_messages, :jsonb
    add_column :users, :public_welcome_message, :jsonb
    add_column :users, :private_welcome_messages, :jsonb
  end
end
