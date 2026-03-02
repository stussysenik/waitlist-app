class CreateReferrals < ActiveRecord::Migration[8.1]
  def change
    create_table :referrals do |t|
      t.references :waitlist, null: false, foreign_key: true
      t.references :referrer, null: false, foreign_key: { to_table: :subscribers }
      t.references :referee, null: false, foreign_key: { to_table: :subscribers }

      t.timestamps
    end

    add_index :referrals, %i[referrer_id referee_id], unique: true
  end
end
