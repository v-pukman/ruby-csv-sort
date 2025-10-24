require 'csv_sort_by_amount_service'

RSpec.describe CsvSortByAmountService do
  let(:input_file) { "sample.csv" }
  let(:output_file) { "rspec_result.csv" }
  let(:batch_size) { 3 }
  let(:service) { CsvSortByAmountService.new(input_file:, output_file:, batch_size:) }
  subject { service.call }
  let(:sorted_rows) do
    %w(
      3000.0
      2500.25
      2500.25
      1500.25
      1500.25
      1500.25
      1500.25
      500.25
      100.0
      100.0
    )
  end

  after do
    File.delete(output_file) if File.exist?(output_file)
  end

  it "returns rows sorted by amount" do
    subject
    rows = []
    CSV.foreach(output_file, headers: true) {|row| rows.push(row["amount"]) }
    expect(rows).to match_array sorted_rows
  end
end
