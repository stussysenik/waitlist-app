class WaitlistsController < ApplicationController
  before_action :set_waitlist, only: %i[show edit update destroy]

  def index
    @waitlists = current_user.waitlists.ordered
  end

  def show
    @pagy, @subscribers = pagy(@waitlist.subscribers.recent)
    @chart_data = Rails.cache.fetch("waitlist:#{@waitlist.id}:chart_data", expires_in: 10.minutes) do
      @waitlist.subscribers
               .where(created_at: 30.days.ago..)
               .group_by_day(:created_at)
               .count
    end
    @daily_stats = @waitlist.daily_stats.recent.ordered
  end

  def new
    unless current_user.can_create_waitlist?
      redirect_to waitlists_path, alert: "You've reached the waitlist limit for your plan. Upgrade to create more."
      return
    end
    @waitlist = current_user.waitlists.build
  end

  def create
    unless current_user.can_create_waitlist?
      redirect_to waitlists_path, alert: "You've reached the waitlist limit for your plan. Upgrade to create more."
      return
    end

    @waitlist = current_user.waitlists.build(waitlist_params)

    if @waitlist.save
      redirect_to @waitlist, notice: "Waitlist created! Share your page: /#{@waitlist.slug}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @waitlist.update(waitlist_params)
      redirect_to @waitlist, notice: "Waitlist updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @waitlist.destroy!
    redirect_to waitlists_path, notice: "Waitlist deleted.", status: :see_other
  end

  private

  def set_waitlist
    @waitlist = current_user.waitlists.find_by!(slug: params[:id])
  end

  def waitlist_params
    params.require(:waitlist).permit(:name, :slug, :headline, :description, :cta_text, :brand_color, :status, :referral_enabled, :launch_date)
  end
end
