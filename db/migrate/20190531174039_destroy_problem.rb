class DestroyProblem < ActiveRecord::Migration[5.2]
  def change
    drop_table :problems
  end
end
