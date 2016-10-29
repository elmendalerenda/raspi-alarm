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
end
