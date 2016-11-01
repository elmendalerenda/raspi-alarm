require 'cronedit'

module RaspiAlarm
  class Scheduler
    class << self
      def add(alarm)
        CronEdit::Crontab.Add(alarm.id, "#{alarm.cron_time} #{Dir.pwd}/scripts/ring.sh #{Dir.pwd}")
      end

      def ls
        CronEdit::Crontab.List
      end

      def rm(alarm)
        CronEdit::Crontab.Remove(alarm.id)
      end
    end
  end
end
