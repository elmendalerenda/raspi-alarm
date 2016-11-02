require 'test_helper'

class TestIntegrationScheduler < Minitest::Test
  def test_integration_fetch_upcoming_alarms
    # copy your client_secret.json to the project root
    RaspiAlarm.configure do |config|
      config.google_client_secret_json_path = './client_secret.json'
      config.google_credentials_path = File.join('./', '.credentials', "raspi-alarm.yaml")
    end

    RaspiAlarm::GCalendar.new.fetch_upcoming

    pass
  end

  def test_integration_schedule_an_alarm
    alarm = RaspiAlarm::Alarm.new(DateTime.new(2002, 10, 31, 4, 3, 2))

    RaspiAlarm::Scheduler.add(alarm)

    scheduled = RaspiAlarm::Scheduler.ls
    assert_match(/3 4 31 10 \* bash .*ring.sh.*/, scheduled[alarm.id])

    RaspiAlarm::Scheduler.rm(alarm)
    assert(RaspiAlarm::Scheduler.ls.empty?)
  end
end
