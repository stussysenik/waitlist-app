class Referral < ApplicationRecord
  belongs_to :waitlist, counter_cache: true
  belongs_to :referrer, class_name: "Subscriber"
  belongs_to :referee, class_name: "Subscriber"

  validates :referee_id, uniqueness: { scope: :referrer_id }

  after_create_commit :reward_referrer

  private

  def reward_referrer
    Subscriber.where(id: referrer_id).update_all("referral_count = referral_count + 1")
    referrer.reload.move_up!(1)
  end
end
