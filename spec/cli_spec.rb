require 'spec_helper'

class String
  def truncate(length)
    size > length + 1 ? "#{self[0..length]}..." : self
  end
end

COMMANDS = {
  :A => {
    :usage => 'A [ALLOC_SIZE] [PID]',
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
    :desc => "Print the memory's contents"
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

# Formats all commands like thor's `help`
def format_all_cmds
  COMMANDS.values.map do |info|
    format_cmd :usage => info[:usage], :desc => info[:desc]
  end.join "\n  "
end

RSpec.describe 'CLI', :type => :aruba do
  before(:each) { run 'bin/prog4', :exit_timeout => 0.01 }

  describe 'quit' do
    it 'quits the program' do
      type 'quit'
      expect(last_command_started).to have_exit_status 0
    end
  end

  describe 'help' do
    let(:help) { "Input: help\n\nCommands:\n  #{format_all_cmds}\n\nInput: " }

    context 'when called with no args' do
      it 'shows general usage' do
        type 'help'
        expect(last_command_started).to have_output help
      end
    end

    COMMANDS.each_pair do |cmd, info|
      context "when called with `#{cmd}`" do
        let(:output) do
          "Input: help #{cmd}" \
            "\n\nUsage:\n  #{info[:usage]}\n\n#{info[:desc]}\nInput: "
        end

        it "shows help for `#{cmd}`" do
          type "help #{cmd}"
          expect(last_command_started).to have_output output
        end
      end
    end
  end

  describe 'M' do
    let(:output) do
      "Input: M 32 4\nInput: \n32 bytes physical memory " \
      "(8 frames) has been created.\n"
    end

    it 'allocates memory' do
      type 'M 32 4'
      expect(last_command_stopped).to have_output output
    end
  end

  describe 'A' do
    before(:each) { type 'M 4 2' }

    let(:granted) do
      <<~OUTPUT.gsub "Input:\n", "Input: \n"
        Input: M 4 2
        Input: A 3 9001
        Input:
        4 bytes physical memory (2 frames) has been created.


        3 bytes of memory have been allocated for process 9001.
      OUTPUT
    end

    let(:lacking_memory) do
      <<~OUTPUT.gsub "Input:\n", "Input: \n"
        Input: M 4 2
        Input: A 16 9001
        Input:
        4 bytes physical memory (2 frames) has been created.


        Not enough memory!
      OUTPUT
    end

    it 'allocates memory to a process' do
      type 'A 3 9001'
      expect(last_command_stopped).to have_output granted
    end

    context "if the request can't be granted" do
      it 'issues an error messege' do
        type 'A 16 9001'
        expect(last_command_stopped).to have_output lacking_memory
      end
    end
  end

  describe 'P' do
    let(:output) do
      <<~OUTPUT.gsub "Input:\n", "Input: \n"
        Input: M 4 2
        Input: A 2 9001
        Input: P
        Input:
        4 bytes physical memory (2 frames) has been created.


        2 bytes of memory have been allocated for process 9001.


        f1->p0 (proc9001): 00
        f2: 00
      OUTPUT
    end

    it 'prints physical memory' do
      type 'M 4 2'
      type 'A 2 9001'
      type 'P'
      expect(last_command_stopped).to have_output output
    end
  end
end
