class MarketingController < ApplicationController
  allow_unauthenticated_access
  layout "public"

  def index
    expires_in 1.hour, public: true
  end
end
