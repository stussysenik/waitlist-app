class CleanupSessionsJob < ApplicationJob
  queue_as :analytics

  def perform
    Session.where(updated_at: ..30.days.ago).delete_all
  end
end
