require "csv"
require "time"

# This is a helper service, fields are hardcoded

class CsvGenerateService
  def initialize(output_file:, rows_count:)
    @output_file = output_file
    @rows_count = rows_count
    @headers = %w(timestamp transaction_id user_id amount)
  end

  def call
    CSV.open(@output_file, "w", write_headers: true, headers: @headers) do |csv|
      @rows_count.times do |i|
        csv << build_row
      end
    end
  end

  private

  def build_row
    timestamp = Time.now.utc.iso8601
    transaction_id = "txn#{rand(1..100_000)}"
    user_id = "user#{rand(1..100_000)}"
    amount = rand(1.0..100_000.0).round(2)

    [timestamp, transaction_id, user_id, amount]
  end
end
