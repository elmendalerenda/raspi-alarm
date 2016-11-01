module RaspiAlarm
  class Configuration
    attr_accessor :google_credentials_path
    attr_accessor :google_client_secret_json_path
    attr_accessor :playlist_name
    attr_accessor :calendar_check_period_in_minutes
  end
end
