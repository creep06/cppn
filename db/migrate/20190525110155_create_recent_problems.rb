class CreateRecentProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :recent_problems do |t|
      t.string :name
      t.string :url
      t.integer :point
      t.integer :user_id

      t.timestamps
    end
  end
end
