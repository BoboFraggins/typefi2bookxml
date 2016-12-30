class ListTags
  def self.process_node(node, section_index, chapter_index, front_matter)
    style = node.get_attribute('style') ? node.get_attribute('style').downcase.gsub(' ', '') : nil
    node.add_next_sibling(node.inner_html.strip)
    node.add_next_sibling("<break type=\"space\"/>") if style == 'none'
    node.remove
  end
end
