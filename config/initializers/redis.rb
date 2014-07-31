if ENV["REDISCLOUD_URL"]
    $redis = Redis.new(:driver => :synchrony, :url => ENV["REDISCLOUD_URL"])
end