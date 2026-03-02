class SendWelcomeEmailJob < ApplicationJob
  queue_as :critical

  def perform(subscriber_id)
    subscriber = Subscriber.find_by(id: subscriber_id)
    return unless subscriber

    SubscriberMailer.welcome(subscriber).deliver_now
  end
end
