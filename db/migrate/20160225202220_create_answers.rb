class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :user_id
      t.integer :question_id
      t.integer :question_message_id
      t.text :question_text
      t.integer :answer_message_id
      t.text :answer_text
      t.string :url
      t.jsonb :properties
      t.datetime :asked_at
      t.datetime :answered_at
      t.integer :asked_by

      t.timestamps null: false
    end
  end
end
