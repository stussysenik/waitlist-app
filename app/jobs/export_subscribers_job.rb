class ExportSubscribersJob < ApplicationJob
  queue_as :default

  def perform(waitlist_id, user_id)
    waitlist = Waitlist.find(waitlist_id)
    user = User.find(user_id)

    tempfile = Tempfile.new(["subscribers_export", ".csv"])
    begin
      CSV.open(tempfile.path, "w", headers: true) do |csv|
        csv << %w[position email name referral_code referral_count source joined_at]

        waitlist.subscribers.ordered.find_each do |sub|
          csv << [sub.position, sub.email, sub.name, sub.referral_code, sub.referral_count, sub.source, sub.created_at.iso8601]
        end
      end

      csv_data = File.read(tempfile.path)
      SubscriberMailer.export(user, waitlist, csv_data).deliver_now
    ensure
      tempfile.close
      tempfile.unlink
    end
  end
end
