class SubscriberMailer < ApplicationMailer
  def welcome(subscriber)
    @subscriber = subscriber
    @waitlist = subscriber.waitlist

    mail(
      to: subscriber.email,
      subject: "You're ##{subscriber.position} on the #{@waitlist.name} waitlist!"
    )
  end

  def export(user, waitlist, csv_data)
    @waitlist = waitlist
    attachments["#{waitlist.slug}-subscribers-#{Date.current}.csv"] = csv_data

    mail(
      to: user.email_address,
      subject: "Your #{waitlist.name} subscriber export is ready"
    )
  end
end
