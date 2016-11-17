require 'raspi_alarm/tasks'
module RaspiAlarm
  class Setup
    def initialize(calendar=RaspiAlarm::GCalendar.new, scheduler=RaspiAlarm::AutoScheduler, tasks=RaspiAlarm::Tasks)
      @calendar = calendar
      @scheduler = scheduler
      @tasks = tasks
    end

    def run
      puts "1. Configure Google Calendar"
      @calendar.fetch_upcoming

      puts "2. Setup scheduler"
      @scheduler.configure
      puts "Scheduler configured every #{RaspiAlarm.configuration.calendar_check_period_in_minutes} minutes"

      puts "3. Creating scripts"
      @tasks.create
      puts "scripts created in #{Dir.pwd}/scripts"
    end
  end
end
