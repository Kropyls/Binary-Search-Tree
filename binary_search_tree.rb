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

# build tree class
class Tree
  attr_accessor :root

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
    @root = priv_insert(leaf)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def priv_insert(leaf_node, node = @root)
    return leaf_node if node.nil?

    case leaf_node <=> node
    when -1
      node.left = priv_insert(leaf_node, node.left)
    when 0
      puts 'Can not insert! Value already exists in tree'
    when 1
      node.right = priv_insert(leaf_node, node.right)
    end
    node
  end
end

arr = [1, 2, 7, 4, 23, 8, 9, 4, 55, 3, 5, 7, 9, 67, 6345, 324]
x = Tree.new(arr)
x.insert(55)
x.pretty_print
