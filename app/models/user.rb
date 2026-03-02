class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :waitlists, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :plan, { free: 0, starter: 1, pro: 2 }

  def plan_waitlist_limit
    case plan
    when "free" then 1
    when "starter" then 5
    when "pro" then Float::INFINITY
    end
  end

  def plan_subscriber_limit
    case plan
    when "free" then 100
    when "starter" then 5_000
    when "pro" then Float::INFINITY
    end
  end

  def can_create_waitlist?
    waitlists.count < plan_waitlist_limit
  end

  def trial_active?
    trial_ends_at.present? && trial_ends_at > Time.current
  end
end
