# frozen_string_literal: true

require 'set'

module SetRefinements
  refine Set do
    def take!(n)
      selected = take(n).to_set
      selected.each { |e| delete e }
    end
  end
end

class InsufficientMemoryError < StandardError
  def initalize(msg = "Not Enough Memory!")
  end
end

class Memory
  using SetRefinements

  attr_reader :size, :frame_size, :data, :free_frames

  def initialize(mem_size:, frame_size:)
    @size = mem_size
    @frame_size = frame_size
    @data = (0..mem_size - 1).each_with_index.map { |e, i| [i, 0] }.to_h
    @free_frames = (0...@data.keys.each_slice(frame_size).size).to_set
  end

  def num_frames
    @data.keys.each_slice(frame_size).size
  end

  def get(frame:, offset:)
    raise ArgumentError, 'invalid frame' unless (0..num_frames).cover?(frame)
    raise ArgumentError, 'invalid offset' unless (0..@frame_size).cover?(offset)

    @data[frame * @frame_size + offset]
  end

  def allocate!(amount:)
    pages_needed = (amount / @frame_size) +
                   ((amount % @frame_size).zero? ? 0 : 1)

    raise InsufficientMemoryError if pages_needed > free_frames.size

    @free_frames.take! pages_needed
  end
end
