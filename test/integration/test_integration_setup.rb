require 'test_helper'
require 'raspi_alarm/setup'

class TestSetAlarm < Minitest::Test
  include Stubs

  def test_integration_prepare_gcalendar
    tasks = stub(create: nil)
    scheduler = stub(configure: nil)

    RaspiAlarm.configure do |config|
      config.google_client_secret_json_path = './client_secret2.json'
      config.google_credentials_path = File.join('./', '.credentials', "raspi-alarm.yaml")
    end

    exception = assert_raises {
      RaspiAlarm::Setup.new(RaspiAlarm::GCalendar.new, scheduler, tasks).run
    }

    assert_kind_of(RaspiAlarm::GCalendar::ClientSecretNotFound, exception)
  end

  def test_integration_prepare_autoscheduler
    tasks = stub(create: nil)
    calendar = stub(fetch_upcoming: [])

    RaspiAlarm.configure do |config|
      config.calendar_check_period_in_minutes = 10
    end

    RaspiAlarm::Setup.new(calendar, RaspiAlarm::AutoScheduler, tasks).run

    scheduled = RaspiAlarm::Scheduler.ls
    assert_match(/10 \* \* \* \* bash .*autoschedule.sh.*/, scheduled['autoschedule'])

    CronEdit::Crontab.Remove('autoschedule')
    assert(RaspiAlarm::Scheduler.ls.empty?)
  end

  def test_integration_prepare_scripts
    scheduler = stub(configure: nil)
    calendar = stub(fetch_upcoming: [])
    RaspiAlarm::Setup.new(calendar, scheduler).run

    autoschedule_lines = File.readlines('scripts/autoschedule.sh')
    autoschedule_found = autoschedule_lines.find { |l| l =~ /.*autoschedule.*/ }
    assert(autoschedule_found)

    ring_lines = File.readlines('scripts/ring.sh')
    ring_found = ring_lines.find { |l| l =~ /.*ring.*/ }
    assert(ring_found)

    `rm scripts/*.sh`
  end
end
