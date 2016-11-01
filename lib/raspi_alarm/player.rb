require 'ruby-mpd'

module RaspiAlarm
  class Player
    class << self
      def play_playlist(name=RaspiAlarm.configuration.playlist_name)
        mpd = MPD.new
        mpd.connect

        clear_queue(mpd)
        load_songs(mpd, name)
        mpd.shuffle
        mpd.play
        mpd.disconnect
      end

      private

      def clear_queue(mpd)
        mpd.clear
      end

      def load_songs(mpd, name)
        mpd.playlists.select { |pl| pl.name == name }.each { |pl| pl.load }
      end
    end
  end
end
