# frozen_string_literal: true

# tlc
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(root)
    @data = root
  end

  def <=>(other)
    data <=> other.data
  end
end

# build tree class
class Tree
  attr_accessor :root

  def initialize(arr)
    arr.uniq!.sort!
    # build tree here
    @root = build_tree(arr)
  end

  # assumes array is sorted and duplicates removed
  def build_tree(arr)
    return nil if arr.empty?

    mid = (arr.count / 2.0).ceil - 1
    left_arr = arr[0...mid]
    right_arr = arr[(mid + 1)...arr.count]
    root = Node.new(arr[mid])
    root.left = build_tree(left_arr)
    root.right = build_tree(right_arr)
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

arr = [1, 2, 7, 4, 23, 8, 9, 4, 55, 3, 5, 7, 9, 67, 6345, 324]
x = Tree.new(arr)
x.pretty_print

