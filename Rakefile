require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/test*.rb']
end

task :ring do
  RaspiAlarm::Player.play_playlist
end

task :autoschedule do
  $LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
  require 'raspi_alarm'
  RaspiAlarm::AutoScheduler.new.run
end


task :default => :test
