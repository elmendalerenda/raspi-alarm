require 'test_helper'

class TestScheduler< Minitest::Test
  include Stubs

  def test_fetch_upcoming_alarms
    now = DateTime.now
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

  def test_convert_time_to_cron
    an_alarm = RaspiAlarm::Alarm.new(DateTime.new(2002, 10, 31, 4, 3, 2))

    assert_equal('3 4 31 10 *', an_alarm.cron_time)
  end

  def test_validate_scheduler_config
    RaspiAlarm.configure do |config|
      config.calendar_check_period_in_minutes = 0
    end

    exception = assert_raises {
      RaspiAlarm::Scheduler.add_autoschedule
    }

    assert_kind_of(RaspiAlarm::Scheduler::InvalidPeriod, exception)
  end

  def test_auto_schedule_an_alarm
    an_alarm = RaspiAlarm::Alarm.new(DateTime.new(2002, 10, 31, 4, 3, 2))
    scheduler = Minitest::Mock.new
    scheduler.expect(:add, nil, [an_alarm])
    calendar = stub(fetch_upcoming: [an_alarm])

    RaspiAlarm::AutoScheduler.new(calendar, scheduler).run

    scheduler.verify
  end
end
