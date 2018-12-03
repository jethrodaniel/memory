# frozen_string_literal: true

class ProcessControlBlock
  attr_reader :pid
  attr_accessor :page_table

  def initialize(pid:)
    @pid = pid
    @page_table = []
  end
end
