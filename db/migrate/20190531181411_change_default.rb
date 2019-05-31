class ChangeDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :solved, :text, default: ""
  end
end
