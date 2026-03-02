class AddPerformanceIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :subscribers, :created_at
    add_index :referrals, :created_at
    add_index :subscribers, [:waitlist_id, :created_at]
    add_index :referrals, [:waitlist_id, :created_at]
    add_column :waitlists, :referrals_count, :integer, default: 0, null: false
  end
end
