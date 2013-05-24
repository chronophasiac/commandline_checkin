require 'time'
# require 'actionpack/lib/action_view/helpers/date_helper'
require 'action_view'
include ActionView::Helpers::DateHelper

class MissionControlCommand
  def initialize(cmd)
    @cmd = cmd
  end

  def self.check_in_path
    ENV['HOME'] + '/.check_in'
  end

  def output
    if @cmd == 'in'
      if !FileTest.exists?(self.class.check_in_path)
        File.open(self.class.check_in_path, 'w') do |f|
          f.puts Time.now
        end
        return "You are checked in as of #{Time.now.strftime('%l:%M %p')}"
      else
        return 'You are already checked in.'
      end
    elsif @cmd == 'out'
      if FileTest.exists?(self.class.check_in_path)
        time_in = Time.parse(File.read(self.class.check_in_path))
        total_time = distance_of_time_in_words_to_now(time_in, true)
        File.delete(self.class.check_in_path)
        return "You are checked out.\nTotal time spent at Mission Control: #{total_time}"
      else
        return 'You are already checked out.'
      end
    else
      return 'Invalid command.'
    end
  end
end
