module RaspiAlarm
  class Alarm < Struct.new(:time)

    def scheduled
      false
    end
  end
end
