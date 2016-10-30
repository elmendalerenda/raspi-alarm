require 'raspi_alarm/configuration'
require 'raspi_alarm/gcalendar'
require 'raspi_alarm/scheduler'

module RaspiAlarm
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
