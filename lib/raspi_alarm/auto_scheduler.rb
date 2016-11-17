module RaspiAlarm
  class AutoScheduler
    def initialize(calendar=RaspiAlarm::GCalendar.new, scheduler=RaspiAlarm::Scheduler)
      @calendar = calendar
      @scheduler = scheduler
    end

    def run
      @calendar.fetch_upcoming.each do |alarm|
        @scheduler.add(alarm)
      end
    end

    def self.configure
      CronEdit::Crontab.Add("autoschedule", "#{RaspiAlarm.configuration.calendar_check_period_in_minutes} * * * * bash #{Dir.pwd}/scripts/autoschedule.sh")
    end
  end
end
