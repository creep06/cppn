class AddColumnToRecentProblem < ActiveRecord::Migration[5.2]
  def change
    add_column :recent_problems, :contest_id, :integer
  end
end
