require "csv"
require_relative "heap"

class CsvSortService
  def initialize(input_file:, output_file:, batch_size:, &compare_block)
    @input_file = input_file
    @output_file = output_file
    @batch_size = batch_size
    @compare_block = compare_block
    @rows = []
    @files = []
    @headers = []
  end

  def call
    split
    merge
    cleanup
    @output_file
  end

  private

  def cleanup
    File.delete(@files.shift) until @files.empty?
    @headers = []
  end

  def split
    CSV.foreach(@input_file, headers: true) do |row|
      @headers = row.headers if @headers.empty?
      @rows << row
      save_batch if @rows.size >= @batch_size
    end

    save_batch if @rows.size > 0

    @files
  end

  def merge
    enums = @files.map do |batch_file|
      enum = CSV.foreach(batch_file, headers: true)
      [enum, get_next_row(enum)]
    end

    heap = Heap.new {|a, b| @compare_block.call(a[1], b[1]) }
    enums.each {|data| heap << data }

    CSV.open(@output_file, "w", write_headers: true, headers: @headers) do |file|
      until heap.empty?
        enum, row = heap.pop
        file << row
        next_row = get_next_row(enum)
        heap << [enum, next_row] if next_row
      end
    end

    @output_file
  end

  def save_batch
    heap = Heap.new(&@compare_block)
    heap << @rows.shift until @rows.empty?

    counter = @files.size + 1
    batch_file_path = "batch_#{counter}_of_#{@input_file}"
    CSV.open(batch_file_path, "w", write_headers: true, headers: @headers) do |file|
      file << heap.pop until heap.empty?
    end

    @files << batch_file_path

    batch_file_path
  end

  def get_next_row(enum)
    enum.next
  rescue StopIteration
    nil
  end
end
