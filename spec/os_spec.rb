# frozen_string_literal: true

require 'spec_helper'

require_relative '../lib/os'

RSpec.describe 'OS' do
  subject(:os) { OS.new :mem_size => 32, :frame_size => 4 }

  describe '.memory' do
    it 'returns the memory' do
      memory = Memory.new :mem_size => 32, :frame_size => 4
      expect(os.memory).to have_attributes(:data => memory.data)
    end
  end

  describe '.allocate!' do
    it 'allocates memory to a process' do
      frames = os.allocate! :alloc_size => 16, :pid => 9001

      expect(os.process_control_blocks.first.pid).to eq(9001)
      expect(os.process_control_blocks.first.page_table).to eq(frames)
      expect(os.memory.free_frames).to eq((4...8).to_a)
    end

    it 'raises an error in case of insufficent memory' do
      expect do
        os.allocate! :alloc_size => 9001, :pid => 1
      end.to raise_error(InsufficientMemoryError)
    end
  end

  describe '.deallocate!' do
    it 'deallocates all memory from a process' do
      frames = os.allocate! :alloc_size => 16, :pid => 9001
      os.deallocate! :pid => 9001

      expect(os.process_control_blocks).to eq([])
    end
  end

  describe '.process_control_blocks' do
    it 'returns the process_control_blocks' do
      page_table_one = os.allocate! :alloc_size => 16, :pid => 9001
      page_table_two = os.allocate! :alloc_size => 16, :pid => 42

      first_pcb = os.process_control_blocks.first
      last_pcb = os.process_control_blocks.last

      expect(first_pcb.pid).to eq(9001)
      expect(first_pcb.page_table).to eq(page_table_one)

      expect(last_pcb.pid).to eq(42)
      expect(last_pcb.page_table).to eq(page_table_two)
    end
  end
end
