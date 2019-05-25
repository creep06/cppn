class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :point_total, default: 0
      t.integer :point_month, default: 0
      t.integer :point_week, default: 0
      t.integer :point_day, default: 0
      t.integer :solved_total, default: 0
      t.integer :solved_month, default: 0
      t.integer :solved_week, default: 0
      t.integer :solved_day, default: 0
      t.timestamps
    end
  end
end
