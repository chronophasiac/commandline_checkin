require 'time'

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
        return 'You are checked in'
      else
        return 'You are already checked in.'
      end
    elsif @cmd == 'out'
      if FileTest.exists?(self.class.check_in_path)
        time_in = Time.parse(File.read(self.class.check_in_path))
        total_time = ((Time.now - time_in).to_i).to_s
        File.delete(self.class.check_in_path)
        return "You are checked out. You were checked in for #{total_time}"
      else
        return 'You are already checked out.'
      end
    else
      return 'Invalid command.'
    end
  end
end
