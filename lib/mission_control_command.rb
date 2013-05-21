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
        File.delete(self.class.check_in_path)
        return 'You are checked out'
      else
        return 'You are already checked out.'
      end
    else
      return 'Invalid command.'
    end
  end
end
