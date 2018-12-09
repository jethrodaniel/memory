# frozen_string_literal: true

# Represents a process control block. This could have been modeled as a
# `Process` object, but that would have conflicted with Ruby's `Process` module.
class ProcessControlBlock
  # @return [Integer] the id of this process
  attr_reader :pid

  # @return [Hash] this page table of this process
  attr_accessor :page_table

  # @param pid [Integer] the id of this process
  def initialize(pid:)
    @pid = pid
    @page_table = {}
  end
end
