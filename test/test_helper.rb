$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'raspi_alarm'

require 'minitest/autorun'

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
