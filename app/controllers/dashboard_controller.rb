class DashboardController < ApplicationController
  def show
    @waitlists = current_user.waitlists.ordered

    @total_subscribers = Rails.cache.fetch("dashboard:#{current_user.id}:total_subscribers", expires_in: 5.minutes) do
      Subscriber.where(waitlist: @waitlists).count
    end

    @total_referrals = Rails.cache.fetch("dashboard:#{current_user.id}:total_referrals", expires_in: 10.minutes) do
      Referral.where(waitlist: @waitlists).count
    end

    @recent_subscribers = Rails.cache.fetch("dashboard:#{current_user.id}:recent_subscribers", expires_in: 5.minutes) do
      Subscriber.where(waitlist: @waitlists).where(created_at: 7.days.ago..).count
    end

    @chart_data = Rails.cache.fetch("dashboard:#{current_user.id}:chart_data", expires_in: 15.minutes) do
      Subscriber.where(waitlist: @waitlists)
                .where(created_at: 30.days.ago..)
                .group_by_day(:created_at)
                .count
    end
  end
end
