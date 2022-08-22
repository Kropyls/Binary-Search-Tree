# frozen_string_literal: true

# tlc
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(root)
    @data = root
    @left = nil
    @right = nil
  end

  def <=>(other)
    data <=> other.data
  end
end

# Class that holds the binary seach tree and its associated methods
class Tree # rubocop:disable Metrics/ClassLength
  attr_reader :root

  def initialize(arr)
    arr.uniq!.sort!
    @root = build_tree(arr)
  end

  # assumes array is sorted and duplicates removed
  def build_tree(arr)
    return nil if arr.empty?

    mid = (arr.count / 2.0).ceil - 1
    root = Node.new(arr[mid])
    root.left = build_tree(arr[0...mid])
    root.right = build_tree(arr[(mid + 1)...arr.count])
    root
  end

  def insert(value)
    leaf = Node.new(value)
    # creating a private method prevents the user adding values without starting at root node
    @root = priv_insert(leaf, @root)
  end

  def delete(value)
    @root = find_and_replace(value, @root) { |node| remove_and_replace(node) }
  end

  def find(value, node = @root)
    case value <=> node.data
    when -1
      find(value, node.left)
    when 0
      node
    when 1
      find(value, node.right)
    end
  end

  def level_order(input_node = @root)
    queue = Queue.new([input_node])
    array = []
    until queue.empty?
      node = queue.pop
      next if node.nil?

      block_given? ? array.push(yield node) : array.push(node.data)
      queue.push(node.left)
      queue.push(node.right)
    end
    array
  end

  def inorder(node = root, &block)
    array = []
    array.push(*inorder(node.left, &block)) unless node.left.nil?

    block_given? ? array.push(block.call(node)) : array.push(node.data)

    array.push(*inorder(node.right, &block)) unless node.right.nil?
    array
  end

  def preorder(node = root, &block)
    array = []
    block_given? ? array.push(block.call(node)) : array.push(node.data)

    array.push(*preorder(node.left, &block)) unless node.left.nil?

    array.push(*preorder(node.right, &block)) unless node.right.nil?
    array
  end

  def postorder(node = root, &block)
    array = []
    array.push(*postorder(node.left, &block)) unless node.left.nil?

    array.push(*postorder(node.right, &block)) unless node.right.nil?

    block_given? ? array.push(block.call(node)) : array.push(node.data)
    array
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def find_and_replace(value, node, &block)
    case value <=> node.data
    when -1
      node.left = find_and_replace(value, node.left, &block)
    when 0
      # found the value, do whatever I want to do here
      node = block.call(node)
    when 1
      node.right = find_and_replace(value, node.right, &block)
    end
    node
  end

  def priv_insert(leaf_node, node)
    return leaf_node if node.nil?

    case leaf_node <=> node
    when -1
      node.left = priv_insert(leaf_node, node.left)
    when 0
      puts 'Can not insert! Value already exists in tree.'
    when 1
      node.right = priv_insert(leaf_node, node.right)
    end
    node
  end

  # three cases, node has no children, node has 1 child, or node has 2 children
  # works with balanced or non-balanced tree
  def remove_and_replace(node)
    if node.right.nil?
      # no children
      return nil if node.left.nil?

      # left child only
      closest_val_node = find_furthest_node(node.left, true)
      block = proc { |edge_node| edge_node.left }
    else
      # right child only
      closest_val_node = find_furthest_node(node.right, false)
      block = proc { |edge_node| edge_node.right }
    end
    # finds the closest node to the input node
    node = find_and_replace(closest_val_node.data, node, &block)
    node.data = closest_val_node.data
    node
  end

  # finds furthest node from given node in declared direction
  def find_furthest_node(node, right)
    next_node = (right ? node.right : node.left)
    return node if next_node.nil?

    find_furthest_node(next_node, right)
  end
end

arr = [1, 2, 7, 4, 23, 8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,24, 25, 26, 27, 28, 29, 30, 6, 9, 4, 55, 3, 5, 7, 9, 67, 6345, 324]
x = Tree.new(arr)
y = x.postorder
p y
