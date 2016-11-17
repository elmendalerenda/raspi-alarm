require 'cronedit'

module RaspiAlarm
  class Scheduler
    class << self
      def add(alarm)
        rm_old(alarm)
        CronEdit::Crontab.Add(alarm.id, "#{alarm.cron_time} bash #{Dir.pwd}/scripts/ring.sh")
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

      def rm_old(alarm)
        ls.select { |id,_| id < alarm.id}.each { |id,v| rm_id(id) }
      end

      def rm_id(id)
        CronEdit::Crontab.Remove(id)
      end
    end
  end
end
