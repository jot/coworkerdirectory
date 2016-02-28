web: bundle exec puma -C config/puma.rb
bot: bundle exec rake run_bot
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 bundle exec rake resque:work QUEUE='*'