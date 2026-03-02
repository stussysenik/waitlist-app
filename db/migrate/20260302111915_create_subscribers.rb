class CreateSubscribers < ActiveRecord::Migration[8.1]
  def change
    create_table :subscribers do |t|
      t.references :waitlist, null: false, foreign_key: true
      t.string :email, null: false
      t.string :name
      t.string :referral_code, null: false
      t.integer :position, null: false
      t.integer :referral_count, default: 0, null: false
      t.string :ip_address
      t.string :source

      t.timestamps
    end

    add_index :subscribers, :referral_code, unique: true
    add_index :subscribers, %i[waitlist_id email], unique: true
    add_index :subscribers, %i[waitlist_id position]
  end
end
