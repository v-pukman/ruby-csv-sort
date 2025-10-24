require_relative "lib/csv_sort_by_amount_service"

# Usage example:
# rake csv_sort input_file="sample.csv" output_file="sorted.csv" batch_size=3

task :csv_sort do
  input_file, output_file, batch_size = ENV["input_file"], ENV["output_file"], ENV["batch_size"].to_i

  abort "Failed! Please fill input_file ENV param" if input_file.nil?
  abort "Failed! Please fill output_file ENV param" if output_file.nil?
  abort "Failed! Please fill batch_size ENV param" if batch_size.nil? || batch_size <= 0
  puts "Start sorting #{ input_file } in #{ batch_size } batches ..."

  CsvSortByAmountService.new(input_file:, output_file:, batch_size:).call

  puts "Saved to #{ output_file }"
  puts "Done!"
end
