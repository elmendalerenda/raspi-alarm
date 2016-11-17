require 'cronedit'

module RaspiAlarm
  class Scheduler
    class InvalidPeriod < StandardError
      def initialize
        super("Invalid period #{RaspiAlarm.configuration.calendar_check_period_in_minutes}, change config.rb to a value between 1 and 59")
      end
    end

    class << self
      def add(alarm)
        rm_old(alarm)
        CronEdit::Crontab.Add(alarm.id, "#{alarm.cron_time} bash #{Dir.pwd}/scripts/ring.sh")
      end

      def add_autoschedule
        CronEdit::Crontab.Add("autoschedule", "#{autoschedule_periods} * * * * bash #{Dir.pwd}/scripts/autoschedule.sh")
      end

      def ls
        CronEdit::Crontab.List
      end

      def rm(alarm)
        rm_id(alarm.id)
      end

      def reset
        CronEdit::Crontab.new.clear!
      end

      private

      def autoschedule_periods
        raise InvalidPeriod unless RaspiAlarm.configuration.calendar_check_period_in_minutes.between?(1, 59)
        minutes = 0..59
        periods = []
        minutes.step(RaspiAlarm.configuration.calendar_check_period_in_minutes).each { |m| periods << m }

        periods.join(',')
      end

      def rm_old(alarm)
        ls.select { |id,_| id < alarm.id}.each { |id,v| rm_id(id) }
      end

      def rm_id(id)
        CronEdit::Crontab.Remove(id)
      end
    end
  end
end
