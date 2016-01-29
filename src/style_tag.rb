class StyleTag
  def self.process_node(node, _, front_matter)
    type = node.get_attribute('type').downcase.gsub(' ', '')
    return '<p align="center"/>' if type == 'strikethrough'
    inner_text = node.children.to_xhtml
    replace = case type
              when 'bold|italic|smallcaps'
                "<emph type=\"10\"><emph type=\"6\">#{inner_text}</emph></emph>"
              when 'bold|italic'
                "<emph type=\"10\">#{inner_text}</emph>"
              when 'bold|superscript'
                "<emph type=\"1\"><emph type=\"7\">#{inner_text}</emph></emph>"
              when 'italic|underline'
                "<emph type=\"2\"><emph type=\"4\">#{inner_text}</emph></emph>"
              when 'italic|smallcaps'
                "<emph type=\"2\"><emph type=\"6\">#{inner_text}</emph></emph>"
              when 'bold'
                "<emph type=\"1\">#{inner_text}</emph>"
              when /italic/.match(type)
                "<emph type=\"2\">#{inner_text}</emph>"
              when 'underline'
                "<emph type=\"4\">#{inner_text}</emph>"
              when /smallcaps/.match(type)
                "<emph type=\"6\">#{inner_text}</emph>"
              when /superscript/.match(type)
                "<emph type=\"7\">#{inner_text}</emph>"
              when 'subscript'
                "<emph type=\"8\">#{inner_text}</emph>"
              when 'allcaps'
                inner_text.to_upper
              else
                inner_text
              end
    node.name = 'p'
    node.set_attribute('align', (front_matter ? 'center' : 'left'))
    node.remove_attribute 'type'
  end
end
