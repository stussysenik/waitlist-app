class Subscriber < ApplicationRecord
  belongs_to :waitlist, counter_cache: true
  has_many :referrals_as_referrer, class_name: "Referral", foreign_key: :referrer_id, dependent: :destroy
  has_many :referral_as_referee, class_name: "Referral", foreign_key: :referee_id, dependent: :destroy

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :waitlist_id, message: "is already on this waitlist" }
  validates :referral_code, presence: true, uniqueness: true

  before_validation :generate_referral_code, on: :create
  before_validation :assign_position, on: :create

  after_create_commit -> { broadcast_replace_to waitlist, target: "subscriber_count_#{waitlist_id}", partial: "public_pages/subscriber_count", locals: { waitlist: waitlist } }
  after_create_commit :invalidate_dashboard_caches

  normalizes :email, with: ->(e) { e.strip.downcase }

  # Retry save if position conflicts due to concurrent inserts
  def save(**options)
    super
  rescue ActiveRecord::RecordNotUnique => e
    if e.message.include?("subscribers.waitlist_id, subscribers.position") && (@position_retries ||= 0) < 5
      @position_retries += 1
      self.position = (waitlist.subscribers.maximum(:position) || 0) + 1
      retry
    end
    raise
  end

  scope :ordered, -> { order(position: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  def referral_url(request = nil)
    base = request ? "#{request.protocol}#{request.host_with_port}" : ""
    "#{base}/#{waitlist.slug}?ref=#{referral_code}"
  end

  def move_up!(positions = 1)
    new_position = [position - positions, 1].max
    return if new_position == position

    old_position = position

    self.class.transaction do
      blocker = waitlist.subscribers.find_by(position: new_position)
      if blocker
        # Swap positions using a temp value to avoid unique constraint violation
        self.class.where(id: id).update_all(position: -1)
        self.class.where(id: blocker.id).update_all(position: old_position)
        self.class.where(id: id).update_all(position: new_position)
      else
        update_columns(position: new_position)
      end
    end

    self.position = new_position
  end

  private

  def generate_referral_code
    self.referral_code ||= begin
      attempts = 0
      loop do
        attempts += 1
        length = attempts > 10 ? 12 : 8
        code = SecureRandom.alphanumeric(length).downcase
        break code unless Subscriber.exists?(referral_code: code)
      end
    end
  end

  def assign_position
    self.position ||= (waitlist.subscribers.maximum(:position) || 0) + 1
  end

  def invalidate_dashboard_caches
    Rails.cache.delete_matched("dashboard:#{waitlist.user_id}:*")
    Rails.cache.delete("waitlist:#{waitlist_id}:growth_rate")
  end
end
