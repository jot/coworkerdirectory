module SlackCabinbot
  class Service
    LOCK = Mutex.new
    @services = {}

    class << self
      def start!(token)
        fail 'Token already known.' if @services.key?(token)
        EM.next_tick do
          server = SlackCabinbot::Server.new(token: token)
          LOCK.synchronize do
            @services[token] = server
          end
          restart!(server)
        end
      rescue StandardError => e
        logger.error e
      end

      def stop!(token)
        LOCK.synchronize do
          fail 'Token unknown.' unless @services.key?(token)
          EM.next_tick do
            @services[token].stop!
            @services.delete(token)
          end
        end
      rescue StandardError => e
        logger.error e
      end

      def logger
        # Rails.logger
        @logger ||= begin
          $stdout.sync = true
          Logger.new(STDOUT)
        end
      end

      def start_from_database!
        Team.all.find_each do |team|
          start! team.bot_access_token
        end

        EM.add_periodic_timer(30) do
          begin
            Team.all.find_each do |team|
              start! team.bot_access_token unless @services.key?(team.bot_access_token)
            end
          rescue => e
            log_error(e)
          end
        end

      end

      def restart!(server, wait = 1)
        server.auth!
        server.start_async
      rescue StandardError => e
        logger.error "#{server.token[0..10]}***: #{e.message}, restarting in #{wait} second(s)."
        sleep(wait)
        EM.next_tick do
          restart! server, [wait * 2, 60].min
        end
      end
    end
  end
end