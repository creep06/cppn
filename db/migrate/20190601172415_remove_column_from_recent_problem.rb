class RemoveColumnFromRecentProblem < ActiveRecord::Migration[5.2]
  def change
    remove_columns :recent_problems, :name, :url, :point
    add_column :recent_problems, :problem_id, :integer
  end
end
