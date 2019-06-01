class CreateProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :problems do |t|
      t.string :name
      t.string :abbr
      t.string :url
      t.integer :point
      t.integer :contest_id

      t.timestamps
    end
  end
end
