# frozen_string_literal: true

require 'spec_helper'

require_relative '../lib/memory'

RSpec.describe 'Memory' do
  subject(:memory) { Memory.new :mem_size => 32, :frame_size => 4 }

  describe '.size' do
    it 'returns the physical memory size' do
      expect(memory.size).to eq(32)
    end
  end

  describe '.frame_size' do
    it 'returns the maximum size of each frame' do
      expect(memory.frame_size).to eq(4)
    end
  end

  describe '.free_frames' do
    it 'returns a list of free frames' do
      expect(memory.free_frames).to eq((0...8).to_a)
    end
  end

  describe '.get' do
    it 'retrives an element from physical memory' do
      element = memory.get :frame => 4, :offset => 3
      expect(element).to eq(0)
    end
  end

  describe '.allocate!' do
    it 'gives up the specified memory' do
      allocated = memory.allocate! :amount => 16

      expect(allocated).to eq((0...4).to_a)
      expect(memory.free_frames).to eq((4...8).to_a)
    end

    it 'raises an error in case of insufficent memory' do
      expect do
        memory.allocate! :amount => 9001
      end.to raise_error(InsufficientMemoryError)
    end
  end
end
