module SlackCabinbot
  class Service
    LOCK = Mutex.new
    @services = {}

    class << self
      def start!(team)
        fail 'Token already known.' if @services.key?(team.token)
        EM.next_tick do
          logger.info "Starting team #{team.name}."
          server = SlackCabinbot::Server.new(team: team)
          LOCK.synchronize do
            @services[team.token] = server
          end
          EM.defer do
            restart!(team, server)
            # EM.next_tick do
            #   nudge!(team)
            # end
          end
        end
      rescue StandardError => e
        logger.error e
      end

      def stop!(team)
        LOCK.synchronize do
          fail 'Token unknown.' unless @services.key?(team.token)
          EM.next_tick do
            @services[team.token].stop!
            @services.delete(team.token)
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
        until EM.reactor_running?; end
        Team.active.find_each do |team|
          start! team
        end

        EM.add_periodic_timer(30) do
          begin
            Team.active.find_each do |team|
              start! team unless @services.key?(team.token)
            end
          rescue StandardError => e
            logger.error e
          end
        end

      end

      def restart!(team, server, wait = 1)
        server.start_async
      rescue StandardError => e
        case e.message
        when 'account_inactive', 'invalid_auth' then
          logger.error "#{team.name}: #{e.message}, team will be deactivated."
          team.deactivate!
        else
          logger.error "#{team.name}: #{e.message}, restarting in #{wait} second(s)."
          sleep(wait)
          EM.next_tick do
            restart! team, server, [wait * 2, 60].min
          end
        end
      end
    end
  end
end