module Webhooks
  class StripeController < ApplicationController
    allow_unauthenticated_access
    skip_forgery_protection

    def create
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, ENV["STRIPE_WEBHOOK_SECRET"])
      rescue JSON::ParserError, Stripe::SignatureVerificationError
        head :bad_request
        return
      end

      case event.type
      when "checkout.session.completed"
        handle_checkout_completed(event.data.object)
      when "customer.subscription.updated"
        handle_subscription_updated(event.data.object)
      when "customer.subscription.deleted"
        handle_subscription_deleted(event.data.object)
      end

      head :ok
    end

    private

    def handle_checkout_completed(session)
      user = User.find_by(stripe_customer_id: session.customer)
      return unless user

      plan = session.metadata["plan"]
      user.update!(plan: plan) if plan.present?
    end

    def handle_subscription_updated(subscription)
      user = User.find_by(stripe_customer_id: subscription.customer)
      return unless user

      if subscription.status == "active"
        price_id = subscription.items.data.first&.price&.id
        plan = price_to_plan(price_id)
        user.update!(plan: plan) if plan
      end
    end

    def handle_subscription_deleted(subscription)
      user = User.find_by(stripe_customer_id: subscription.customer)
      return unless user

      user.update!(plan: :free)
    end

    def price_to_plan(price_id)
      case price_id
      when ENV["STRIPE_STARTER_PRICE_ID"] then :starter
      when ENV["STRIPE_PRO_PRICE_ID"] then :pro
      end
    end
  end
end
