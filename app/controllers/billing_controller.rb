class BillingController < ApplicationController
  def show
    @plan = current_user.plan
  end
end
