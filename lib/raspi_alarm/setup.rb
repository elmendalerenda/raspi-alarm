module RaspiAlarm
  class Setup
    def initialize(calendar=RaspiAlarm::GCalendar.new, scheduler=RaspiAlarm::AutoScheduler)
      @calendar = calendar
      @scheduler = scheduler
    end

    def run
      puts "1. Configure Google Calendar"
      @calendar.fetch_upcoming

      puts "2. Setup scheduler"
      @scheduler.configure
      puts "Scheduler configured every #{RaspiAlarm.configuration.calendar_check_period_in_minutes} minutes"
    end
  end
end
