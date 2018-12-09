# frozen_string_literal: true

# An error to be raised in case there is not enough memory to grant a request
class InsufficientMemoryError < StandardError
end

# Represents physical memory
class Memory
  # @return [Integer] the memory size
  attr_reader :size

  # @return [Integer] the size of a frame
  attr_reader :frame_size

  # @return [Hash] the physical memory
  attr_reader :data

  # @return [Array] the free frame list
  attr_reader :free_frames

  # Create a new memory instance
  #
  # @param mem_size [Integer] the memory size
  # @param frame_size [Integer] the size of a frame
  def initialize(mem_size:, frame_size:)
    @size = mem_size
    @frame_size = frame_size
    @data = (0..mem_size - 1).each_with_index.map { |_e, i| [i, 0] }.to_h
    @free_frames = (0...@data.keys.each_slice(frame_size).size).to_a
  end

  # @return [Integer] the number of frames
  def num_frames
    @data.keys.each_slice(frame_size).size
  end

  # Retrieve an element from memory
  #
  # @param frame [Integer] the frame to access
  # @param offset [Integer] the offset from the start of the frame
  #
  # @return [Integer] the contents of memory at the specified location
  def get(frame:, offset:)
    raise ArgumentError, 'invalid frame' unless (0..num_frames).cover?(frame)
    raise ArgumentError, 'invalid offset' unless (0..@frame_size).cover?(offset)

    @data[frame * @frame_size + offset]
  end

  # Give up frames to allocate the requested amount of memory
  #
  # @param amount [Integer] the amount of memory to allocate
  #
  # @return [Array] the frames that can be used to grant the request
  def allocate!(amount:)
    frames_needed = (amount / @frame_size) +
                    ((amount % @frame_size).zero? ? 0 : 1)

    if frames_needed > free_frames.size
      raise InsufficientMemoryError, 'Not Enough Memory'
    end

    @free_frames.shift frames_needed
  end

  # Frees the given frames, i.e add them back to the free frame list
  #
  # @param frames [Array] the frames to deallocate
  #
  # @return [Integer] the number of bytes that were freed
  def free!(frames:)
    @free_frames.push *frames

    to_h.select { |frame, _content| frames.include? frame }.values.flatten.size
  end

  # Converts memory into a hash by frame
  #
  # @return [Hash] a hash of frame numbers to memory values
  def to_h
    @data.values
         .each_slice(@frame_size)
         .map.with_index { |e, i| [i, e] }
         .to_h
  end
end
