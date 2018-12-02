# frozen_string_literal: true

require 'thor'

# The commands
class CLI < Thor

  # Don't show app name in command help, i.e, instead of
  # `app command desc`, use `command desc`
  def self.banner(task, namespace = false, subcommand = false)
    "#{task.formatted_usage(self, false, subcommand)}"
  end

  desc 'M [MEM_SIZE] [FRAME_SIZE]', 'Creates a simulated physical memory space'
  def M(mem_size, frame_size)
    puts "#{mem_size} Bytes physical memory (5 frames) has been created."
  end

  desc 'P', "Prints the simulated physical memory's contents"
  def P
    puts "physical memory!"
  end

  desc 'A [MEM_SIZE] [PID]', 'Allocates a chunk of memory for a process'
  def A(mem_size, pid)
    puts "#{mem_size} bytes of memory have been allocated for process #{pid}."
  end

  desc 'D [PID]', 'Deallocates memory from a process'
  def D(pid)
    puts "#{mem_size} bytes of memory have been dellocated from process #{pid}."
  end

  desc 'W [PAGE] [OFFSET] [PID]', "Writes `1` to a process's memory location"
  def W(page, offset, pid)
    puts "writing `1` to pid:#{pid}, page #{page}, offset #{offset}"
  end

  desc 'R [PAGE] [OFFSET] [PID]', "Reads a byte from a process's memory location"
  def R(page, offset, pid)
    puts "reading pid:#{pid}, page #{page}, offset #{offset}"
  end

  desc 'quit', 'Exits the program'
  def quit
    Thor::Shell::Basic.new.say "\nExiting...", :cyan
    exit
  end
end
