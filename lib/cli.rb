# frozen_string_literal: true

require 'thor'

# The commands
class CLI < Thor
  # Don't show app name in command help, i.e, instead of
  # `app command desc`, use `command desc`
  def self.banner(task, _namespace = false, subcommand = false)
    task.formatted_usage(self, false, subcommand).to_s
  end

  desc 'M [MEM_SIZE] [FRAME_SIZE]', 'Create a simulated physical memory space'
  def M(mem_size, frame_size)
    # @memory = MemSpace.new
    puts frame_size
    puts "#{mem_size} Bytes physical memory (5 frames) has been created."
  end

  desc 'P', "Print the simulated physical memory's contents"
  def P
    puts 'physical memory!'
  end

  desc 'A [MEM_SIZE] [PID]', 'Allocate a chunk of memory to a process'
  def A(mem_size, pid)
    puts "#{mem_size} bytes of memory have been allocated for process #{pid}."
  end

  desc 'D [PID]', 'Deallocate memory from a process'
  def D(pid)
    puts "pass bytes of memory have been dellocated from process #{pid}."
  end

  desc 'W [PAGE] [OFFSET] [PID]', "Write a `1` to a process's memory location"
  def W(page, offset, pid)
    puts "writing `1` to pid:#{pid}, page #{page}, offset #{offset}"
  end

  desc 'R [PAGE] [OFFSET] [PID]', "Read a byte from a process's memory location"
  def R(page, offset, pid)
    puts "reading pid:#{pid}, page #{page}, offset #{offset}"
  end

  desc 'quit', 'Exit the program'
  def quit
    Thor::Shell::Basic.new.say "\nExiting...", :cyan
    exit
  end

  # Aliases
  %w[e ex exi exit q qu qui].each { |c| map c => :quit }
  %w[h he hel].each { |c| map c => :help }
end
