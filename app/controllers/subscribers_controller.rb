class SubscribersController < ApplicationController
  before_action :set_waitlist

  def index
    redirect_to @waitlist
  end

  def show
    @subscriber = @waitlist.subscribers.find(params[:id])
  end

  def destroy
    subscriber = @waitlist.subscribers.find(params[:id])
    subscriber.destroy!
    redirect_to @waitlist, notice: "Subscriber removed.", status: :see_other
  end

  def export
    ExportSubscribersJob.perform_later(@waitlist.id, current_user.id)
    redirect_to @waitlist, notice: "CSV export started. You'll receive it by email shortly."
  end

  private

  def set_waitlist
    @waitlist = current_user.waitlists.find_by!(slug: params[:waitlist_id])
  end
end
