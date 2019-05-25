class CreateProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :problems do |t|
      t.string :name
      t.string :url
      t.integer :point
      t.integer :user_id

      t.timestamps
    end
  end
end
