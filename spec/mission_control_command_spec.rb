require 'rspec'
require 'time'

require_relative '../lib/mission_control_command'

describe MissionControlCommand do
  it 'has a check in path' do
    expect(MissionControlCommand.check_in_path).to include('check_in')
  end

  context 'checking in' do
  let(:cmd_in) { MissionControlCommand.new('in') }
  let(:now) { Time.now.strftime('%l:%M %p') }

    it 'acknowledges my check in' do
      expect(cmd_in.output).to include('You are')
    end

    it 'creates a check in file' do
      check_in_path = cmd_in.class.check_in_path
      if FileTest.exists?(check_in_path)
        FileUtils.rm(check_in_path)
      end

      cmd_in.output
      expect(check_in_path).to be_true
    end

    it 'timestamps the checkin file at the time of checkin' do
      cmd_in.output
      time = File.read(cmd_in.class.check_in_path).chomp
      expect(time).to eql((Time.now).to_s)
    end

    it 'throws a checkin error if you try to checkin twice' do
      cmd2 = MissionControlCommand.new('in')
      cmd_in.output
      cmd2.output
      expect(cmd2.output).to include('You are already checked in.')
    end

    it 'does not change the timestamp if you try to check in again' do
      cmd_in.output
      initial_time = File.read(cmd_in.class.check_in_path).chomp
      cmd2 = MissionControlCommand.new('in')
      cmd2.output
      final_time = File.read(cmd_in.class.check_in_path).chomp
      expect(initial_time).to eql(final_time)
    end

    context 'checking out' do
      let(:cmd_out) { MissionControlCommand.new('out') }

      it 'acknowledges my check out' do
        expect(cmd_out.output).to include("You are checked out")
      end

      it 'deletes the check in file' do
        check_in_path = cmd_out.class.check_in_path
        expect(FileTest.exists?(check_in_path)).to eql(false)
      end

      it 'tells you how long you were checked in' do
        cmd_in.output
        time_in = Time.parse(File.read(cmd_in.class.check_in_path).chomp)
        sleep(1)
        out = cmd_out.output
        expect(out).to include("5")
      end

      it 'includes "seconds"' do
        cmd_in.output
        time_in = Time.parse(File.read(cmd_in.class.check_in_path).chomp)
        sleep(1)
        out = cmd_out.output
        total_time = (Time.now - time_in).to_i
        expect(out).to include("seconds")
      end

      it 'throws a checkout error if you try to checkout twice' do
        cmd2 = MissionControlCommand.new('out')
        cmd_out.output
        cmd2.output
        expect(cmd2.output).to include('You are already checked out.')
      end
    end

  end


end
