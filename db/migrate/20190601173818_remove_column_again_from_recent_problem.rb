class RemoveColumnAgainFromRecentProblem < ActiveRecord::Migration[5.2]
  def change
    remove_column :recent_problems, :contest_id
  end
end
