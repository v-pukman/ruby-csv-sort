require 'heap'

RSpec.describe Heap do
  let(:heap) { Heap.new }

  describe "#push" do
    it "adds item to heap storage" do
      heap.push(5)
      expect(heap.size).to eq 1
    end

    it "has an alias method" do
      heap << 5 << 10
      expect(heap.size).to eq 2
    end

    it "rebalances the heap" do
      heap << 5
      heap << 1
      heap << 10
      heap << 2
      expect(heap.peak).to eq 10
    end
  end

  describe "#pop" do
    it "removes item from heap storage" do
      heap << 10
      heap << 1
      expect(heap.size).to eq 2
      heap.pop
      expect(heap.size).to eq 1
    end

    it "returns max item" do
      heap << 5
      heap << 2
      heap << 1
      heap << 10
      expect(heap.pop).to eq 10
      expect(heap.pop).to eq 5
      expect(heap.pop).to eq 2
      expect(heap.pop).to eq 1
    end
  end

  describe "#size" do
    it "returns size of the heap" do
      expect(heap.size).to eq 0
      heap << 5
      expect(heap.size).to eq 1
    end
  end

  describe "#peak" do
    it "returns max item" do
      heap << 1
      heap << 3
      heap << 2
      heap << 1
      expect(heap.peak).to eq 3
    end
  end

  describe "#empty?" do
    it "reflects the heap's size" do
      expect(heap.empty?).to eq true
      heap << 5
      expect(heap.empty?).to eq false
      heap.pop
      expect(heap.empty?).to eq true
    end
  end

  context "when custom compare block is passed:" do
    let(:heap) do
      Heap.new do |a, b|
        a[:amount] < b[:amount]
      end
    end
    let(:user500) { {name: 'user500', amount: 500} }
    let(:user100) { {name: 'user100', amount: 100} }
    let(:user300) { {name: 'user300', amount: 300} }
    it "uses custom block to compare" do
      heap << user500
      heap << user100
      heap << user300
      expect(heap.pop).to eq user100
      expect(heap.pop).to eq user300
      expect(heap.pop).to eq user500
    end
  end
end
