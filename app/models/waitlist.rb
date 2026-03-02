class Waitlist < ApplicationRecord
  include Sluggable

  belongs_to :user
  has_many :subscribers, dependent: :delete_all
  has_many :referrals, dependent: :delete_all
  has_many :daily_stats, dependent: :delete_all

  enum :status, { draft: 0, active: 1, paused: 2, launched: 3 }

  validates :name, presence: true
  validates :headline, length: { maximum: 200 }
  validates :brand_color, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "must be a valid hex color (e.g. #4F46E5)" }, allow_blank: true

  broadcasts_refreshes

  scope :ordered, -> { order(created_at: :desc) }

  def to_param
    slug
  end

  def total_referrals
    referrals_count
  end

  def growth_rate(days: 7)
    Rails.cache.fetch("waitlist:#{id}:growth_rate", expires_in: 10.minutes) do
      recent = subscribers.where(created_at: days.days.ago..).count
      previous = subscribers.where(created_at: (days * 2).days.ago..days.days.ago).count
      return 0 if previous.zero?
      ((recent - previous).to_f / previous * 100).round(1)
    end
  end
end
