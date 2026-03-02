class HealthController < ApplicationController
  allow_unauthenticated_access

  def show
    checks = {
      status: "ok",
      timestamp: Time.current.iso8601,
      database: check_database,
      cache: check_cache,
      queue: check_queue
    }

    status = checks.values_at(:database, :cache, :queue).all? { |c| c[:status] == "ok" } ? :ok : :service_unavailable
    render json: checks, status: status
  end

  private

  def check_database
    ActiveRecord::Base.connection.execute("SELECT 1")
    { status: "ok" }
  rescue => e
    { status: "error", message: e.message }
  end

  def check_cache
    Rails.cache.write("health_check", "ok", expires_in: 1.minute)
    value = Rails.cache.read("health_check")
    { status: value == "ok" ? "ok" : "error" }
  rescue => e
    { status: "error", message: e.message }
  end

  def check_queue
    { status: "ok", adapter: ActiveJob::Base.queue_adapter.class.name }
  rescue => e
    { status: "error", message: e.message }
  end
end
