require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end

task "resque:scheduler_setup" => :environment
