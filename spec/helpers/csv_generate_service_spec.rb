require 'helpers/csv_generate_service'

RSpec.describe CsvGenerateService do
  let(:output_file) { "rspec_generate_result.csv" }
  let(:rows_count) { 100 }
  let(:service) { CsvGenerateService.new(output_file:, rows_count:) }
  subject { service.call }

  after do
    File.delete(output_file) if File.exist?(output_file)
  end

  it "generates csv with hardcoded fields set" do
    subject

    row = CSV.foreach(output_file, headers: true).next
    expect(row["amount"].to_f).to be >= 1.0
    expect(row["amount"].to_f).to be <= 100_000.0

    expect(row["timestamp"].empty?).to eq false
    expect(row["transaction_id"].empty?).to eq false
    expect(row["user_id"].empty?).to eq false
  end

  it "generates csv with declared rows count" do
    subject
    rows = CSV.read(output_file, headers: true)
    expect(rows.size).to eq rows_count
  end
end
