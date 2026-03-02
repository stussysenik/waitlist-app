class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string
    add_column :users, :stripe_customer_id, :string
    add_column :users, :plan, :integer, default: 0, null: false
    add_column :users, :trial_ends_at, :datetime
    add_index :users, :stripe_customer_id, unique: true
  end
end
