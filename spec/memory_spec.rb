# frozen_string_literal: true

require 'spec_helper'

require_relative '../lib/memory'

RSpec.describe 'Memory' do
  subject(:memory) { Memory.new :mem_size => 16, :frame_size => 4 }

  describe '.size' do
    it 'returns the physical memory size' do
      expect(memory.size).to eq(16)
    end
  end

  describe '.frame_size' do
    it 'returns the maximum size of each frame' do
      expect(memory.frame_size).to eq(4)
    end
  end

  describe '.free_frames' do
    it 'returns a list of free frames' do
      expect(memory.free_frames).to eq((0...4).to_a)
    end
  end

  describe '.read' do
    it 'retrives an element from physical memory' do
      element = memory.read :frame => 3, :offset => 3
      expect(element).to eq(0)
    end
  end

  describe '.write!' do
    let!(:written) { memory.write! :frame => 3, :offset => 3 }

    it 'writes a `1` to memory' do
      element = memory.read :frame => 3, :offset => 3
      expect(element).to eq(1)
    end

    it 'returns `1`' do
      expect(written).to eq(1)
    end
  end

  describe '.allocate!' do
    it 'gives up the specified memory' do
      allocated = memory.allocate! :amount => 8

      expect(allocated).to eq((0...2).to_a)
      expect(memory.free_frames).to eq((2...4).to_a)
    end

    it 'raises an error in case of insufficent memory' do
      expect do
        memory.allocate! :amount => 9001
      end.to raise_error(InsufficientMemoryError)
    end
  end

  describe '.free!' do
    before(:each) do
      memory.allocate! :amount => 8
      memory.free! :frames => [0, 1]
    end

    it 'adds the frames from the free frame list' do
      expect(memory.free_frames).to contain_exactly(*(0...4).to_a)
    end
  end

  describe '.to_h' do
    let(:hash) do
      {
        0 => [0, 0, 0, 0],
        1 => [0, 0, 0, 0],
        2 => [0, 0, 0, 0],
        3 => [0, 0, 0, 0]
      }
    end

    it 'returns a frame to values hash' do
      expect(memory.to_h).to eq(hash)
    end
  end
end
