workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  Redis.current = Redis.new(url: ENV["REDIS_URL"])
  $redis = Redis.current
  Resque.redis = $redis

  Rails.cache.reconnect if Rails.cache.respond_to? :reconnect
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end