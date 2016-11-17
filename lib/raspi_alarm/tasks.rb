module RaspiAlarm
  class Tasks
    class << self
      def create
        create_script("autoschedule")
        create_script("ring")
      end

      private

      def create_script(action)
        open("scripts/#{action}.sh", 'w') do |f|
          f.puts "#!/usr/bin/env bash"
          f.puts "RAKE=#{`which rake`}"
          f.puts "cd #{Dir.pwd}"
          f.puts "$RAKE #{action} > output.txt 2>&1"
        end
      end
    end
  end
end
