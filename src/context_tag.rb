class ContextTag
  def self.process_node(node, _, _, _)
    type = node.get_attribute('type').downcase.gsub(' ', '')
    case type
    when 'figure'
      node.name = 'figgrp'
      node.remove_attribute 'id'
      node.remove_attribute 'type'
    else
      node.add_next_sibling(node.children)
      node.remove
    end
  end
end
