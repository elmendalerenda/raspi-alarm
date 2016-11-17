require 'whenever'

module RaspiAlarm
  class Scheduler
    class << self
      def add(alarm)
        write_schedule(autoschedule_cron_line, alarm_cron_line(alarm))
      end

      def add_autoschedule
        write_schedule(autoschedule_cron_line)
      end

      def ls
        %x[crontab -l].split("\n").reject{ |s| s.start_with?("#") || s.empty? }
      end

      def ls_alarms
        ls.select { |task| task =~ /.*ring.*/ }
      end

      def reset
        begin
          Whenever::CommandLine.execute(clear: true)
        rescue SystemExit
        end
      end

      private

      def autoschedule_cron_line
        "every '#{RaspiAlarm.configuration.calendar_check_period_in_minutes} * * * *' do rake 'autoschedule' end"
      end

      def alarm_cron_line(alarm)
        "every '#{alarm.cron_time}' do rake 'ring' end"
      end

      def write_schedule(*lines)
        open('config/schedule.rb', 'w') do |f|
          lines.each { |line| f.puts line }
        end

        begin
          Whenever::CommandLine.execute(update: true)
        rescue SystemExit
        end
      end
    end
  end
end
