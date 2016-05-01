class CreateEnquiries < ActiveRecord::Migration
  def change
    create_table :enquiries do |t|
      t.integer :user_id
      t.string :name
      t.string :email
      t.string :subject
      t.text :text
      t.datetime :sent_at

      t.timestamps null: false
    end
  end
end
