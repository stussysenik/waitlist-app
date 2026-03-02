class ProcessAnalyticsJob < ApplicationJob
  queue_as :analytics

  def perform
    yesterday = Date.yesterday

    # Batch aggregate with GROUP BY instead of N+1
    signups = Subscriber.where(created_at: yesterday.all_day)
                        .group(:waitlist_id)
                        .count

    referrals = Referral.where(created_at: yesterday.all_day)
                        .group(:waitlist_id)
                        .count

    waitlist_ids = (signups.keys + referrals.keys).uniq
    return if waitlist_ids.empty?

    waitlist_ids.each do |waitlist_id|
      DailyStat.upsert(
        {
          waitlist_id: waitlist_id,
          date: yesterday,
          signups_count: signups.fetch(waitlist_id, 0),
          referrals_count: referrals.fetch(waitlist_id, 0),
          created_at: Time.current,
          updated_at: Time.current
        },
        unique_by: [:waitlist_id, :date]
      )
    end
  end
end
