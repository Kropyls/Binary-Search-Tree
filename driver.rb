# frozen_string_literal: true

require_relative './binary_search_tree'

# create the tree
arr = Array.new(15) { rand(1..100) }
tree = Tree.new(arr)

def print_info(tree)
  puts "Balanced: " + tree.balanced?.to_s
  p "level_order: " + tree.level_order.to_s
  p "preorder: " + tree.preorder.to_s
  p "inorder: " + tree.inorder.to_s
  p "postorder: " + tree.postorder.to_s
end

# "tests" below
print_info(tree)
tree.insert(105)
tree.insert(110)
tree.insert(111)
tree.insert(108)
puts "Balanced: " + tree.balanced?.to_s
puts "Rebalancing..."
tree.rebalance
print_info(tree)
