# frozen_string_literal: true

class ProcessControlBlock
  attr_reader :pid
  attr_accessor :page_table

  def initialize(pid:)
    @pid = pid
    @page_table = []
  end

  # Read a byte from memory
  def read(page:, offset:)
  end

  # Write a `1` to memory
  def write!(page:, offset:)
  end
end
