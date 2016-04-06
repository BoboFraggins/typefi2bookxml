class LinkTag
  def self.process_node(node, _, _, _)
    node.add_next_sibling(node.inner_html.strip)
    node.remove
  end
end
