#Raspi Alarm

An alarm clock system for the raspberry pi

**Features**:

 - Schedule events from a Google Calendar into cron events
 - Play a song from a playlist when the alarm goes off

## Installation and usage

** Check the [Wiki](https://github.com/elmendalerenda/raspi-alarm/wiki) for the system requirements and their installation **


 1. Clone this repository.
 2. Install the dependencies with  

	```bash
	$> bundle install
	```

 3. Edit `config/config.rb` and set up your preferred configuration
	```ruby
     RaspiAlarm.configure do |config|
       config.google_client_secret_json_path = './client_secret.json'
       config.google_credentials_path = File.join('./', '.credentials', "raspi-alarm.yaml")
       config.playlist_name = 'Wake me up'
     end 
 ```
 
 4. Run the following command to finish the configuration
 
 ```bash
	$> rake setup
	```

 5. Test that everything works: Schedule any event in you calendar and a song will be played.
   

## Run the tests

For unit tests: 
```bash
$> rake test
```
For all the tests including the integration tests: 
```bash
$> rake all_tests
```

