class CreateWaitlists < ActiveRecord::Migration[8.1]
  def change
    create_table :waitlists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.string :headline
      t.text :description
      t.string :cta_text, default: "Join the waitlist"
      t.string :brand_color, default: "#4F46E5"
      t.integer :status, default: 0, null: false
      t.boolean :referral_enabled, default: true
      t.date :launch_date
      t.integer :subscribers_count, default: 0, null: false

      t.timestamps
    end

    add_index :waitlists, :slug, unique: true
    add_index :waitlists, :status
  end
end
