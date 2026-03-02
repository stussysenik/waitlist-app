class RecordPageViewJob < ApplicationJob
  queue_as :analytics

  def perform(waitlist_id)
    DailyStat.record_page_view!(waitlist_id)
  end
end
