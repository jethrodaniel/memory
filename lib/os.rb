# frozen_string_literal: true

require_relative 'memory'
require_relative 'process_control_block'

# Represents an operating system
class OS
  # @return [Array] the process control blocks for each process
  attr_reader :process_control_blocks

  # @return [Memory] the os's memory
  attr_reader :memory

  # Creates a new os
  #
  # @param mem_size [Integer] the amount of memory to create
  # @param frame_size [Integer] the size of a frame
  def initialize(mem_size:, frame_size:)
    @memory = Memory.new :mem_size => mem_size, :frame_size => frame_size

    @process_control_blocks = []
  end

  # Allocates memory to a process
  #
  # @param alloc_size [Integer] the amount of memory to allocate
  # @param pid [Integer] the pid of the process to allocate memory to
  #
  # @return [Hash] the page table of the process that was allocated memory
  def allocate!(alloc_size:, pid:)
    pcb = @process_control_blocks.select { |p| p.pid == pid }.first

    if pcb.nil?
      pcb = ProcessControlBlock.new :pid => pid
      @process_control_blocks.push pcb
    end

    alloc_frames = @memory.allocate! :amount => alloc_size

    pcb.page_table
       .size
       .upto(pcb.page_table.size + alloc_frames.size - 1)
       .zip(alloc_frames)
       .each { |page, frame| pcb.page_table[page] = frame }

    pcb.page_table
  end

  # Removes all memory from a process
  #
  # @param pid [Integer] the process to deallocate memory from
  #
  # @return [Array] the memory's free frame list
  def deallocate!(pid:)
    pcb = @process_control_blocks.select { |p| p.pid == pid }.first

    @process_control_blocks.delete pcb

    @memory.free! :frames => pcb.page_table.values
  end

  # @return [String] the contents of memory, including processes
  def print_memory
    @memory.to_h.map do |frame, contents|
      pcb = @process_control_blocks.reject do |p|
        p.page_table.key(frame).nil?
      end.first

      page = pcb.nil? ? nil : pcb.page_table.key(frame)

      if page.nil?
        "f#{frame + 1}: #{contents.join}"
      else
        "f#{frame + 1}->p#{page} (proc#{pcb.pid}): #{contents.join}"
      end
    end.join "\n"
  end

  # Read a byte from a process's memory
  #
  # @param page [Integer] the page number
  # @param offset [Integer] the offset from the start of the page
  # @param pid [Integer] the process's id
  #
  # @return [Integer] the content of memory at the specified location
  def read(page:, offset:, pid:); end

  # Write a `1` to a process's memory
  #
  # @param page [Integer] the page number
  # @param offset [Integer] the offset from the start of the page
  # @param pid [Integer] the process's id
  #
  # @return [Integer] the value that was written to memory, `1`
  def write!(page:, offset:, pid:)
  end

  private

  # @param pid [Integer] the process control block to retrieve
  #
  # @return [ProcessControlBlock] the specified process control block, else nil
  def get_pcb(pid:)
    @process_control_blocks.select { |pcb| pcb.pid == pid }.first
  end
end
