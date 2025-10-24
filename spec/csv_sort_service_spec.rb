require 'csv_sort_service'

RSpec.describe CsvSortService do
  let(:input_file) { "sample.csv" }
  let(:output_file) { "rspec_result.csv" }
  let(:batch_size) { 3 }
  let(:compare_block) do
    lambda {|a, b| a["amount"].to_f > b["amount"].to_f }
  end
  let(:service) { CsvSortService.new(input_file:, output_file:, batch_size:, &compare_block) }
  subject { service.call }

  after do
    File.delete(output_file) if File.exist?(output_file)
  end

  describe "read attributes" do
    it { expect(service.input_file).to eq input_file }
    it { expect(service.output_file).to eq output_file }
    it { expect(service.batch_size).to eq batch_size }
    it { expect(service.compare_block).to eq compare_block }
  end

  context "when sorts by amount field:" do
    it "returns rows sorted by amount" do
      subject
      rows = []
      CSV.foreach(output_file, headers: true) {|row| rows.push(row["amount"]) }
      expect(rows.first).to eq "3000.0"
      expect(rows.last).to eq "100.0"
    end
  end

  context "when sorts by timestamp field:" do
    let(:compare_block) do
      lambda {|a, b| DateTime.parse(a["timestamp"]) > DateTime.parse(b["timestamp"])}
    end

    it "returns rows sorted by time" do
      subject
      rows = []
      CSV.foreach(output_file, headers: true) {|row| rows.push(row["timestamp"]) }
      expect(rows.first).to eq "2023-09-03T12:49:00Z"
      expect(rows.last).to eq "2023-09-03T12:45:00Z"
    end
  end
end
