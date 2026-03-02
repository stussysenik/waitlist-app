class PublicPagesController < ApplicationController
  allow_unauthenticated_access
  layout "public"

  rate_limit to: 5, within: 1.minute, only: :subscribe

  before_action :set_waitlist

  def show
    # Buffer page views in cache, flush periodically via FlushPageViewsJob
    Rails.cache.increment("page_views:#{@waitlist.id}:#{Date.current}")

    fresh_when etag: [@waitlist, @waitlist.subscribers_count], public: true

    if params[:subscribed] && params[:code]
      @just_subscribed = true
      @subscriber = @waitlist.subscribers.find_by(referral_code: params[:code])
    end
    @subscriber ||= Subscriber.new
  end

  def subscribe
    @subscriber = @waitlist.subscribers.build(subscriber_params)
    @subscriber.ip_address = request.remote_ip
    @subscriber.source = params[:ref].present? ? "referral" : "direct"

    if @subscriber.save
      process_referral if params[:ref].present?
      DailyStat.record_signup!(@waitlist.id)
      SendWelcomeEmailJob.perform_later(@subscriber.id)

      redirect_to public_page_path(@waitlist.slug, subscribed: 1, code: @subscriber.referral_code)
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_waitlist
    @waitlist = Waitlist.active.find_by!(slug: params[:slug])
  end

  def subscriber_params
    params.require(:subscriber).permit(:email, :name)
  end

  def process_referral
    referrer = @waitlist.subscribers.find_by(referral_code: params[:ref])
    return unless referrer

    Referral.create(waitlist: @waitlist, referrer: referrer, referee: @subscriber)
    DailyStat.record_referral!(@waitlist.id)
  end
end
