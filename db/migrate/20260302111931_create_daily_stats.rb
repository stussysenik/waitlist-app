class CreateDailyStats < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_stats do |t|
      t.references :waitlist, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :signups_count, default: 0, null: false
      t.integer :referrals_count, default: 0, null: false
      t.integer :page_views_count, default: 0, null: false

      t.timestamps
    end

    add_index :daily_stats, %i[waitlist_id date], unique: true
  end
end
