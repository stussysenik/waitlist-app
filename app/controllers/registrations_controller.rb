class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_registration_path, alert: "Try again later." }

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.plan = :free
    @user.trial_ends_at = 14.days.from_now

    if @user.save
      start_new_session_for @user
      redirect_to dashboard_path, notice: "Welcome to WaitlistApp!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end
