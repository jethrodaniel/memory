# frozen_string_literal: true

require 'thor'

require_relative 'os'

# Thor command class for the cli
class CLI < Thor
  # Don't show app name in command help, i.e, instead of
  # `app command desc`, use `command desc`
  def self.banner(task, _namespace = false, subcommand = false)
    task.formatted_usage(self, false, subcommand).to_s
  end

  desc 'M [MEM_SIZE] [FRAME_SIZE]', 'Create a simulated physical memory space'
  def M(mem_size, frame_size)
    @os = OS.new :mem_size => mem_size.to_i, :frame_size => frame_size.to_i

    puts "#{@os.memory.size} bytes physical memory " \
         "(#{@os.memory.num_frames} frames) have been created."
  end

  desc 'P', "Print the memory's contents"
  def P
    puts @os.nil? ? 'Must allocate memory first!' : @os.print_memory
  end

  desc 'A [ALLOC_SIZE] [PID]', 'Allocate a chunk of memory to a process'
  def A(alloc_size, pid)
    begin
      pages = @os.allocate! :alloc_size => alloc_size.to_i, :pid => pid.to_i
      mem_size = pages.values.size * @os.memory.frame_size
    rescue InsufficientMemoryError
      puts 'Not enough memory!'
      return
    end

    puts "#{mem_size} bytes of memory have been allocated for process #{pid}."
  end

  desc 'D [PID]', 'Deallocate memory from a process'
  def D(pid)
    begin
      freed = @os.deallocate! :pid => pid.to_i
    rescue NonExistentProcessError
      puts "A process with that pid doesn't exist!"
      return
    end

    puts "#{freed} bytes of memory have been dellocated from process #{pid}."
  end

  # @note The page and offset are 1-indexed
  desc 'W [PAGE] [OFFSET] [PID]', "Write a `1` to a process's memory location"
  def W(page, offset, pid)
    @os.write! :page => page.to_i - 1,
               :offset => offset.to_i - 1,
               :pid => pid.to_i
  rescue ArgumentError
    puts 'Illegal memory access!'
  end

  # @note The page and offset are 1-indexed
  desc 'R [PAGE] [OFFSET] [PID]', "Read a byte from a process's memory location"
  def R(page, offset, pid)
    puts @os.read :page => page.to_i - 1,
                  :offset => offset.to_i - 1,
                  :pid => pid.to_i
  rescue ArgumentError
    puts 'Illegal memory access!'
  end

  desc 'quit', 'Exit the program'
  def quit
    Thor::Shell::Basic.new.say "\nExiting...", :cyan
    exit
  end
end
