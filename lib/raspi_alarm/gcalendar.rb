require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

require 'raspi_alarm/configuration'
require 'raspi_alarm/alarm'

module RaspiAlarm
  class GCalendar
    class ClientSecretNotFound < StandardError
      def initialize
        super("We could not find the file #{RaspiAlarm.configuration.google_client_secret_json_path}, change config.rb to the correct path")
      end
    end

    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    APPLICATION_NAME = 'Raspi Alarm'
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

    def initialize(service=initialize_google_service)
      @service = service
    end

    def fetch_upcoming
      calendar_id = 'primary'
      response = @service.list_events(calendar_id,
                                     max_results: 1,
                                     single_events: true,
                                     order_by: 'startTime',
                                     time_min: Time.now.iso8601)

      response.items.map do |event|
        Alarm.new(event.start.date || event.start.date_time)
      end
    end

    private

    def initialize_google_service
      raise ClientSecretNotFound.new unless File.exist?( RaspiAlarm.configuration.google_client_secret_json_path)

      Google::Apis::CalendarV3::CalendarService.new.tap { |s|
        s.client_options.application_name = APPLICATION_NAME
        s.authorization = authorize
      }
    end
    ##
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    #
    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def authorize
      FileUtils.mkdir_p(File.dirname(RaspiAlarm.configuration.google_credentials_path))

      client_id = Google::Auth::ClientId.from_file(RaspiAlarm.configuration.google_client_secret_json_path)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: RaspiAlarm.configuration.google_credentials_path)
      authorizer = Google::Auth::UserAuthorizer.new(
        client_id, SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        url = authorizer.get_authorization_url(
          base_url: OOB_URI)
        puts "Open the following URL in the browser and enter the " +
          "resulting code after authorization"
        puts url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI)
      end
      credentials
    end
  end
end
