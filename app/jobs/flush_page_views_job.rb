class FlushPageViewsJob < ApplicationJob
  queue_as :analytics

  def perform
    Waitlist.find_each do |waitlist|
      key = "page_views:#{waitlist.id}:#{Date.current}"
      count = Rails.cache.read(key).to_i
      next unless count > 0

      Rails.cache.delete(key)
      DailyStat.record_page_views_batch!(waitlist.id, count)
    end
  end
end
