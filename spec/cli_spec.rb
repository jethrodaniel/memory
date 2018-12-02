require 'spec_helper'

RSpec.describe 'CLI', :type => :aruba do
  before(:each) { run 'bin/memry', :exit_timeout => 1 }

  describe 'help' do
    let(:help) do
      <<~OUTPUT.gsub(/Input:\n/, "Input: ")
      Input: help
      Commands:
        A [MEM_SIZE] [PID]         # Allocates a chunk of memory for a process
        D [PID]                    # Deallocates memory from a process
        M [MEM_SIZE] [FRAME_SIZE]  # Creates a simulated physical memory space
        P                          # Prints the simulated physical memory's contents
        R [PAGE] [OFFSET] [PID]    # Reads a byte from a process's memory location
        W [PAGE] [OFFSET] [PID]    # Writes `1` to a process's memory location
        help [COMMAND]             # Describe available commands or one specific co...
        quit                       # Exits the program

      Input:
      OUTPUT
    end

    context 'when called with no args' do
      it 'shows general usage' do
        type 'help'

        expect(last_command_started).to have_output help
      end
    end

    context 'when called with `help`' do
      let(:help_help) do
        <<~OUTPUT.gsub(/Input:\n/, "Input: ")
        Input: help help
        Usage:
          help [COMMAND]

        Describe available commands or one specific command
        Input:
        OUTPUT
      end

      it 'shows help for `help`' do
        type 'help help'
        expect(last_command_started).to have_output help_help
      end
    end
  end
end
