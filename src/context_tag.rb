class ContextTag
  def self.process_node(node, _, _)
    node.add_next_sibling(node.children)
    node.remove
  end
end
