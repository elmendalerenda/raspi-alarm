module RaspiAlarm
  class Alarm < Struct.new(:time)
    def id
      time.to_s
    end

    def cron_time
      "#{time.min} #{time.hour} #{time.day} #{time.month} *"
    end
  end
end
