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
  end
end
