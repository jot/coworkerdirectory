class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :team_id
      t.text :text
      t.text :response
      t.integer :priority
      t.integer :author_id

      t.timestamps null: false
    end
  end
end
