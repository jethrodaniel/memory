# frozen_string_literal: true

# Represents a process control block. This could have been modeled as a
# `Process` object, but that would conflict with Ruby's `Process` module.
class ProcessControlBlock
  # @return [Integer] the id of this process
  attr_reader :pid

  # @return [Hash] the process's page table
  attr_accessor :page_table

  # @param pid [Integer] thepid to use
  def initialize(pid:)
    @pid = pid
    @page_table = {}
  end

  # Read a byte from memory
  def read(page:, offset:); end

  # Write a `1` to memory
  def write!(page:, offset:); end
end
