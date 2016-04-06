class XRefTag
  def self.process_node(node, _, _, _)
    id = node.get_attribute('refId')
    node.name = 'wordref'
    node.remove_attribute 'refId'
    node.remove_attribute 'refType'
    node.remove_attribute 'partType'
    node.remove_attribute 'textType'
    node.set_attribute('rids', "px#{id.gsub('keyphrase-', '')}")
  end
end
