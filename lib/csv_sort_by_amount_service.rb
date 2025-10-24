require_relative "csv_sort_service"

class CsvSortByAmountService < CsvSortService
  def compare_block
    lambda{|a, b| a["amount"].to_f > b["amount"].to_f }
  end
end
