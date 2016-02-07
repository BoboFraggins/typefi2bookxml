class ContentTag
  def self.process_node(node)
    node.name = 'book'
    node.remove_attribute 'type'
    node.remove_attribute 'strictSpace'
    node.remove_attribute 'schemaVersion'
    node.remove_attribute 'schemaLocation'
  end
end
