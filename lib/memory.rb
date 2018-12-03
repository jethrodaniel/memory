# frozen_string_literal: true

Frame = Struct.new(:number, :values, :free) do
end

class Memory
  attr_accessor :physical, :frames

  # @param  mem_size    Size of physical memory in bytes
  # @param  frame_size  Size of a frame in bytes
  def initialize(mem_size, frame_size)
    # Physical memory is represented as an array of bytes
    @physical = Array.new(mem_size, 0)

    # Frames are contiguous sections of memory
    @frames = @physical.each_slice(frame_size)
                       .with_index
                       .map { |frame, index| Frame.new(index, frame, true) }
  end
end
