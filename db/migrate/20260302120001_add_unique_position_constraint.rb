class AddUniquePositionConstraint < ActiveRecord::Migration[8.1]
  def change
    remove_index :subscribers, [:waitlist_id, :position]
    add_index :subscribers, [:waitlist_id, :position], unique: true
  end
end
