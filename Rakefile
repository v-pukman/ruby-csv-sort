require_relative "lib/csv_sort_by_amount_service"
require_relative "lib/helpers/csv_generate_service"
require_relative "lib/helpers/benchmark_helpers"

# Usage example:
# rake csv_sort input_file="sample.csv" output_file="sorted.csv" batch_size=3

task :csv_sort do
  input_file, output_file, batch_size = ENV["input_file"], ENV["output_file"], ENV["batch_size"].to_i

  abort "Failed! Please fill input_file ENV param" if input_file.nil?
  abort "Failed! Please fill output_file ENV param" if output_file.nil?
  abort "Failed! Please fill batch_size ENV param" if batch_size.nil? || batch_size <= 0
  puts "Start sorting #{ input_file } with #{ batch_size } batch size ..."

  print_memory_usage do
    print_time_spent do
      CsvSortByAmountService.new(input_file:, output_file:, batch_size:).call
    end
  end

  puts "Saved to #{ output_file }"
  puts "Done!"
end

# Usage example:
# rake csv_generate output_file="1_mil_sample.csv" rows_count="1_000_000"

# Then run sort task:
# rake csv_sort input_file="1_mil_sample.csv" output_file="1_mil_sorted.csv" batch_size=10_000

task :csv_generate do
  output_file, rows_count = ENV["output_file"], ENV["rows_count"].to_i

  abort "Failed! Please fill output_file ENV param" if output_file.nil?
  abort "Failed! Please fill rows_count ENV param" if rows_count.nil? || rows_count <= 0
  puts "Start generating #{ output_file } with #{ rows_count } rows ..."

  CsvGenerateService.new(output_file:, rows_count:).call

  puts "Done!"
end

# Use this bad performance implementation only for the research purposes
# rake csv_sort_bad_performance input_file="1_mil_sample.csv" output_file="1_mil_sorted_BAD.csv"

task :csv_sort_bad_performance do
  input_file, output_file = ENV["input_file"], ENV["output_file"]

  abort "Failed! Please fill input_file ENV param" if input_file.nil?
  abort "Failed! Please fill output_file ENV param" if output_file.nil?

  puts "Start sorting #{ input_file } with bad performance (memory) ..."

  print_memory_usage do
    print_time_spent do

      rows = []
      headers = []
      CSV.foreach(input_file, headers: true) do |row|
        headers = row.headers if headers.empty?
        rows << row
      end
      rows.sort_by!{ |row| row["amount"].to_f }

      CSV.open(output_file, "w", write_headers: true, headers: headers) do |file|
        until rows.empty?
          row = rows.pop
          file << row
        end
      end

    end
  end

  puts "Saved to #{ output_file }"
  puts "Done!"
end
