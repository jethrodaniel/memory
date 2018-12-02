# frozen_string_literal: true

# Simulates physical memory space
class MemSpace
  def initialize
    @physical_memory = @Array.new mem_size, 0
    @frames = nil
    @free_frames = @frames.dup
  end
end

# @param  mem_size    Size of physical memory in bytes
# @param  frame_size  Size of a frame in bytes
def memory_manager(mem_size:, frame_size:); end
