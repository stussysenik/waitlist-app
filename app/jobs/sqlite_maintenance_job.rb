class SqliteMaintenanceJob < ApplicationJob
  queue_as :analytics

  def perform
    ActiveRecord::Base.connection.execute("ANALYZE")
    ActiveRecord::Base.connection.execute("PRAGMA optimize")
  end
end
