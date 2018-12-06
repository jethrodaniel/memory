# frozen_string_literal: true

require_relative 'memory'
require_relative 'process_control_block'

class OS
  attr_reader :process_control_blocks, :memory

  def initialize(mem_size:, frame_size:)
    @memory = Memory.new :mem_size => mem_size, :frame_size => frame_size

    @process_control_blocks = []
  end

  # Allocates memory to a process
  def allocate!(alloc_size:, pid:)
    pcb = @process_control_blocks.select { |pcb| pcb.pid == pid }.first

    if pcb.nil?
      pcb = ProcessControlBlock.new :pid => pid
      @process_control_blocks.push pcb
    end

    pcb.page_table << @memory.allocate!(:amount => alloc_size)
  end

  # Removes all memory from a process
  def deallocate!(pid:)
    pcb = @process_control_blocks.select { |pcb| pcb.pid == pid }.first

    @process_control_blocks.delete pcb

    @memory.free_frames.push *pcb.page_table
  end
end
