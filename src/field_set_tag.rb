class FieldSetTag
  def self.process_node(node, chapter_index, front_matter)
    replace = "<title>#{node.get_attribute('value')}</title>"
    node.add_next_sibling(replace)
    node.remove
  end
end
