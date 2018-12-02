require 'spec_helper'

class String
  def truncate(length)
    size > length + 1 ? "#{self[0..length]}..." : self
  end
end

COMMANDS = {
  :A => {
    :usage => 'A [MEM_SIZE] [PID]',
    :desc => 'Allocate a chunk of memory to a process'
  },
  :D => {
    :usage => 'D [PID]',
    :desc => 'Deallocate memory from a process'
  },
  :M => {
    :usage => 'M [MEM_SIZE] [FRAME_SIZE]',
    :desc => 'Create a simulated physical memory space'
  },
  :P => {
    :usage => 'P',
    :desc => "Print the simulated physical memory's contents"
  },
  :R => {
    :usage => 'R [PAGE] [OFFSET] [PID]',
    :desc => "Read a byte from a process's memory location"
  },
  :W => {
    :usage => 'W [PAGE] [OFFSET] [PID]',
    :desc => "Write a `1` to a process's memory location"
  },
  :help => {
    :usage => 'help [COMMAND]',
    :desc => 'Describe available commands or one specific command'
  },
  :quit => {
    :usage => 'quit',
    :desc => 'Exit the program'
  }
}.freeze

# Formats a command like thor
def format_cmd(usage:, desc:)
  largest_usage = COMMANDS.values.map { |info| info[:usage] }.map(&:size).max
  "#{usage.ljust(largest_usage, ' ')}  # #{desc.truncate(45)}"
end

RSpec.describe 'CLI', :type => :aruba do
  before(:each) { run 'bin/memry', :exit_timeout => 0.01 }

  describe 'quit' do
    it 'quits the program' do
      type 'quit'
      expect(last_command_started).to have_exit_status 0
    end
  end

  describe 'help' do
    let(:help) do
      <<~OUTPUT.gsub(/Input:\n/, 'Input: ')
        Input: help

        Commands:
          #{COMMANDS.values.map do |info|
              format_cmd :usage => info[:usage], :desc => info[:desc]
            end.join("\n  ")}

        Input:
      OUTPUT
    end

    context 'when called with no args' do
      it 'shows general usage' do
        type 'help'

        expect(last_command_started).to have_output help
      end
    end

    COMMANDS.each_pair do |command, info|
      context "when called with `#{command}`" do
        let(:output) do
          <<~OUTPUT.gsub(/Input:\n/, 'Input: ')
            Input: help #{command}

            Usage:
              #{info[:usage]}

            #{info[:desc]}
            Input:
          OUTPUT
        end

        it "shows help for `#{command}`" do
          type "help #{command}"
          expect(last_command_started).to have_output output
        end
      end
    end
  end
end
