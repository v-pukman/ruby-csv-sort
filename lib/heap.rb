class Heap
  def initialize(&compare_block)
    @heap = []
    @compare_block = if block_given?
      compare_block
    else
      lambda{|a, b| a > b }
    end
  end

  def push(item)
    @heap << item
    rebalance_up(size - 1)
    self
  end

  alias :<< :push

  def pop
    return nil if empty?

    swap(0, size - 1)
    item = @heap.pop
    rebalance_down(0)
    item
  end

  def size
    @heap.size
  end

  def empty?
    size == 0
  end

  def peak
    @heap[0]
  end

  private

  def rebalance_up(index)
    return if index == 0

    parent = (index - 1) / 2
    return unless compare(index, parent)

    swap(index, parent)
    rebalance_up(parent)
  end

  def rebalance_down(index)
    left = 2 * index + 1
    right = 2 * index + 2

    if left < size && compare(left, index) && (right >= size || compare(left, right))
      swap(index, left)
      rebalance_down(left)
    elsif right < size && compare(right, index)
      swap(index, right)
      rebalance_down(right)
    end
  end

  def swap(a, b)
    @heap[a], @heap[b] = @heap[b], @heap[a]
  end

  def compare(a, b)
    @compare_block.call(@heap[a], @heap[b])
  end
end
