class AnchorTag
  def self.process_node(node, _, _, _)
    id = node.get_attribute('id')
    if id.start_with?('keyphrase-')
      node.name = 'word'
      node.remove_attribute 'name'
      node.set_attribute('id', "px#{id.gsub('keyphrase-', '')}")
    else
      node.remove
    end
  end
end
