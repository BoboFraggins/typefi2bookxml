class ImageTag
  def self.process_node(node, _, _, _)
    node.name = 'fig'
    node.remove_attribute 'ref'
    node.set_attribute('filename', '')
    node.set_attribute('scale', '1')
    node.set_attribute('id', 'fig_')
  end
end
