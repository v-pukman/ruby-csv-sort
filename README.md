# Sort Large CSV in Ruby

`CsvSortService` implements CSV sorting functionality using `Heap` data structure. This provides large files processing with less memory and time consumption.

## How to use

```
require 'csv_sort_service'

CsvSortService.new(input_file: "sample.csv", output_file: "sorted.csv", batch_size: 300) do |a, b|
  # your sorting logic here - field and order
  a["amount"].to_f > b["amount"].to_f
end.call
```

Or create your custom service by overriding `compare_block`. For example:

```
class CsvSortByAmountService < CsvSortService
  def compare_block
    lambda{|a, b| a["amount"].to_f > b["amount"].to_f }
  end
end

# Then simply call the service:
CsvSortByAmountService.new(input_file: "sample.csv", output_file: "sorted.csv", batch_size: 300).call
```

## Run tests

```
 bundle install
 bin/rspec
```

## Run rake tasks

```
# Generate CSV sample file:
rake csv_generate output_file="1_mil_sample.csv" rows_count="1_000_000"

# Run csv_sort task to sort by "amount" field (CsvSortByAmountService is used by default):
rake csv_sort input_file="1_mil_sample.csv" output_file="1_mil_sorted.csv" batch_size=10_000
```

## Time and memory consumption

Using `CsvSortService` based on `Heap` data structure:

```
# 1 million rows with 10_000 batch size
Time: 0.96 minutes
Memory: 27.48 MB

# 10 millions rows with 10_000 batch size
Time: 15.46 minutes
Memory: 215.03 MB
```

Using standard Ruby `Array#sort_by` method:

```
# 1 million rows
Time: 0.16 minutes
Memory: 879.06 MB

# 10 millions rows
Time: 10.42 minutes
Memory: 3047.25 MB
```
