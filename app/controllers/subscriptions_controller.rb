class SubscriptionsController < ApplicationController
  def create
    plan = params[:plan]
    price_id = case plan
    when "starter" then ENV["STRIPE_STARTER_PRICE_ID"]
    when "pro" then ENV["STRIPE_PRO_PRICE_ID"]
    else
      redirect_to pricing_path, alert: "Invalid plan."
      return
    end

    # Create or reuse Stripe customer
    if current_user.stripe_customer_id.blank?
      customer = Stripe::Customer.create(
        email: current_user.email_address,
        name: current_user.name,
        metadata: { user_id: current_user.id }
      )
      current_user.update!(stripe_customer_id: customer.id)
    end

    session = Stripe::Checkout::Session.create(
      customer: current_user.stripe_customer_id,
      mode: "subscription",
      line_items: [{ price: price_id, quantity: 1 }],
      success_url: "#{billing_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: pricing_url,
      metadata: { user_id: current_user.id, plan: plan }
    )

    redirect_to session.url, allow_other_host: true
  end
end
