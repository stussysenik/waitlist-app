Rack::Attack.throttle("req/ip", limit: 300, period: 5.minutes) do |req|
  req.ip
end

Rack::Attack.throttle("subscribe/ip", limit: 10, period: 1.hour) do |req|
  req.ip if req.post? && req.path.end_with?("/subscribe")
end

Rack::Attack.throttle("login/ip", limit: 10, period: 3.minutes) do |req|
  req.ip if req.post? && req.path == "/session"
end

ActiveSupport.on_load(:after_initialize) do
  Rack::Attack.throttled_responder = lambda do |_request|
    [429, { "Content-Type" => "text/plain" }, ["Rate limit exceeded. Retry later.\n"]]
  end
end
