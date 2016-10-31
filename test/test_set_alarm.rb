require 'test_helper'

module Stubs
  def stub(definitions={})
    Object.new.tap do |stub|
      definitions.map do |method_name, canned_response|
        stub.send :define_singleton_method, method_name do |*args|
          canned_response
        end
      end
    end
  end
end

class TestSetAlarm < Minitest::Test
  include Stubs

  def test_fetch_upcoming_alarms
    now = Time.now
    events = Google::Apis::CalendarV3::Events.new.tap { |e|
      ev = Google::Apis::CalendarV3::Event.new
      date = Google::Apis::CalendarV3::EventDateTime.new
      date.date = now
      ev.start = date
      e.items = [ev]
    }
    service = stub(list_events: events)

    alarms = RaspiAlarm::GCalendar.new(service).fetch_upcoming

    assert_equal(now, alarms.first.time)
  end

  def test_integration_fetch_upcoming_alarms
    skip
    # copy your client_secret.json to the project root
    RaspiAlarm.configure do |config|
      config.google_client_secret_json_path = './client_secret.json'
      config.google_credentials_path = File.join('./', '.credentials', "raspi-alarm.yaml")
    end

    RaspiAlarm::GCalendar.new.fetch_upcoming

    pass
  end

  def test_convert_time_to_cron
    an_alarm = RaspiAlarm::Alarm.new(Time.new(2002, 10, 31, 4, 3, 2))

    assert_equal('3 4 31 10 *', an_alarm.cron_time)
  end

  def test_integration_schedule_an_alarm
    skip
    alarm = RaspiAlarm::Alarm.new(Time.new(2002, 10, 31, 4, 3, 2))

    RaspiAlarm::Scheduler.add(alarm)

    scheduled = RaspiAlarm::Scheduler.ls
    assert_equal("3 4 31 10 * echo 'hello world'", scheduled[alarm.id])

    RaspiAlarm::Scheduler.rm(alarm)
    assert(RaspiAlarm::Scheduler.ls.empty?)
  end

  def test_auto_schedule_an_alarm
    an_alarm = RaspiAlarm::Alarm.new(Time.new(2002, 10, 31, 4, 3, 2))
    scheduler = Minitest::Mock.new
    scheduler.expect(:add, nil, [an_alarm])
    calendar = stub(fetch_upcoming: [an_alarm])

    RaspiAlarm::AutoScheduler.new(calendar, scheduler).run

    scheduler.verify
  end
end
