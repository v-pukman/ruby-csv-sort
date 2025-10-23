require 'csv_sort_service'

RSpec.describe CsvSortService do
  let(:input_file) { "sample.csv" }
  let(:output_file) { "rspec_result.csv" }

  after do
    File.delete(output_file) if File.exist?(output_file)
  end

  context "when sorts by amount field:" do
    subject do
      CsvSortService.new(input_file: input_file, output_file: output_file, batch_size: 3) do |a, b|
        a["amount"].to_f > b["amount"].to_f
      end.call
    end

    it "returns rows sorted by amount" do
      subject
      rows = []
      CSV.foreach(output_file, headers: true) {|row| rows.push(row["amount"]) }
      expect(rows.first).to eq "3000.0"
      expect(rows.last).to eq "100.0"
    end
  end

  context "when sorts by timestamp field:" do
    subject do
      CsvSortService.new(input_file: input_file, output_file: output_file, batch_size: 3) do |a, b|
        DateTime.parse(a["timestamp"]) > DateTime.parse(b["timestamp"])
      end.call
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
