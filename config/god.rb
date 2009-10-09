require 'rubygems'
require 'god'

RAILS_ROOT = File.join(File.dirname(__FILE__), "..")

God.watch do |w|
  w.name = "jobs runner"
  w.interval = 3.seconds # default      
  w.start = "cd #{RAILS_ROOT} && RAILS_ENV=production rake jobs:work"
  w.stop = "killall -q rake || true"
  w.restart = "cd #{RAILS_ROOT} && ((killall -q rake || true) && (RAILS_ENV=production rake jobs:work))"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = File.join(RAILS_ROOT, "tmp/pids/jobs_runner.pid")
  
  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end
end