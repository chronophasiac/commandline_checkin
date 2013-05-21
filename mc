#!/usr/bin/env ruby

require_relative 'lib/mission_control_command'

cmd = MissionControlCommand.new(ARGV[0])
puts cmd.output
