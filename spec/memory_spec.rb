# frozen_string_literal: true

require 'spec_helper'

require_relative '../lib/memory'

RSpec.describe 'Memory' do
  subject { Memory.new(100, 20) }

  describe '.new' do
    it 'initializes a new memory space' do
      expect(subject.physical).to eq(Array.new(100, 0))

      expect(subject.frames.map(&:values)).to eq(Array.new(5, Array.new(20, 0)))
    end
  end
end
