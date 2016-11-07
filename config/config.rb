RaspiAlarm.configure do |config|
  config.google_client_secret_json_path = './client_secret.json'
  config.google_credentials_path = File.join('./', '.credentials', "raspi-alarm.yaml")
  config.playlist_name = 'Wake me up'
  config.calendar_check_period_in_minutes = 1
end
