require 'test_helper'
require 'raspi_alarm/setup'

class TestSetAlarm < Minitest::Test
  include Stubs

  def test_integration_prepare_gcalendar
    scheduler = stub(configure: nil)

    RaspiAlarm.configure do |config|
      config.google_client_secret_json_path = './client_secret2.json'
      config.google_credentials_path = File.join('./', '.credentials', "raspi-alarm.yaml")
    end

    exception = assert_raises {
      RaspiAlarm::Setup.new(RaspiAlarm::GCalendar.new, scheduler).run
    }

    assert_kind_of(RaspiAlarm::GCalendar::ClientSecretNotFound, exception)
  end

  def test_integration_prepare_autoscheduler
    calendar = stub(fetch_upcoming: [])

    RaspiAlarm.configure do |config|
      config.calendar_check_period_in_minutes = 10
    end

    RaspiAlarm::Setup.new(calendar).run

    scheduled = RaspiAlarm::Scheduler.ls
    assert_match(/10 \* \* \* \* bash .*autoschedule.sh.*/, scheduled['autoschedule'])

    CronEdit::Crontab.Remove('autoschedule')
    assert(RaspiAlarm::Scheduler.ls.empty?)
  end
end
