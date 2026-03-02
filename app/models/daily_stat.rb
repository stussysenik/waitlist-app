class DailyStat < ApplicationRecord
  belongs_to :waitlist

  validates :date, presence: true, uniqueness: { scope: :waitlist_id }

  scope :recent, ->(days = 30) { where(date: days.days.ago.to_date..) }
  scope :ordered, -> { order(date: :asc) }

  def self.record_signup!(waitlist_id)
    upsert_stat!(waitlist_id, :signups_count)
  end

  def self.record_referral!(waitlist_id)
    upsert_stat!(waitlist_id, :referrals_count)
  end

  def self.record_page_view!(waitlist_id)
    upsert_stat!(waitlist_id, :page_views_count)
  end

  def self.record_page_views_batch!(waitlist_id, count)
    upsert_stat!(waitlist_id, :page_views_count, count)
  end

  private_class_method def self.upsert_stat!(waitlist_id, column, increment = 1)
    connection.execute(sanitize_sql_array([
      "INSERT INTO daily_stats (waitlist_id, date, #{column}, created_at, updated_at)
       VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(waitlist_id, date) DO UPDATE SET
       #{column} = #{column} + ?, updated_at = CURRENT_TIMESTAMP",
      waitlist_id, Date.current, increment, increment
    ]))
  end
end
