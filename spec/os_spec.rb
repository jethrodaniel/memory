# frozen_string_literal: true

require 'spec_helper'

require_relative '../lib/os'

RSpec.describe 'OS' do
  subject(:os) { OS.new :mem_size => 16, :frame_size => 4 }

  describe '.memory' do
    it 'returns the memory' do
      memory = Memory.new :mem_size => 16, :frame_size => 4
      expect(os.memory).to have_attributes(:data => memory.data)
    end
  end

  describe '.allocate!' do
    it 'allocates memory to a process' do
      frames = os.allocate! :alloc_size => 8, :pid => 9001

      expect(os.process_control_blocks.first.pid).to eq(9001)
      expect(os.process_control_blocks.first.page_table).to eq(frames)
      expect(os.memory.free_frames).to eq((2...4).to_a)
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
      expect(os.process_control_blocks.first.page_table).to eq(frames)

      os.deallocate! :pid => 9001

      expect(os.process_control_blocks).to eq([])
    end
  end

  describe '.process_control_blocks' do
    it 'returns the sum of allocated memory' do
      page_table_one = os.allocate! :alloc_size => 8, :pid => 9001
      page_table_two = os.allocate! :alloc_size => 8, :pid => 42

      first_pcb = os.process_control_blocks.first
      last_pcb = os.process_control_blocks.last

      expect(first_pcb.pid).to eq(9001)
      expect(first_pcb.page_table).to eq(page_table_one)

      expect(last_pcb.pid).to eq(42)
      expect(last_pcb.page_table).to eq(page_table_two)
    end
  end

  describe '.print_memory' do
    before(:each) { os.allocate! :alloc_size => 8, :pid => 9001 }

    let(:output) do
      <<~OUTPUT.gsub /(.*)\n\z/, '\1'
        f1->p1 (proc9001): 0000
        f2->p2 (proc9001): 0000
        f3: 0000
        f4: 0000
      OUTPUT
    end

    it 'prints the contents of physical memory' do
      expect(os.print_memory).to eq(output)
    end
  end

  describe '.write!' do
    before(:each) do
      os.allocate! :alloc_size => 8, :pid => 9001
      os.write! :page => 0, :offset => 0, :pid => 9001
    end

    let(:pcb) { os.get_pcb :pid => 9001 }

    it 'writes a `1`to a memory location of a process' do
      expect(os.memory.read(:frame => 0, :offset => 0)).to eq(1)
    end
  end

  describe '.get_pcb' do
    before(:each) { os.allocate! :alloc_size => 8, :pid => 9001 }

    let(:pcb) do
      ProcessControlBlock.new(:pid => 9001).tap do |pcb|
        pcb.page_table[0] = 0
        pcb.page_table[1] = 1
      end
    end

    it 'returns the specified process control block' do
      expect(os.send(:get_pcb, :pid => 9001).page_table).to eq(pcb.page_table)
    end
  end
end
