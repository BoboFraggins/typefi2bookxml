class StyleTag
  def self.process_node(node, _, _, front_matter)
    type = node.get_attribute('type').downcase.gsub(' ', '')
    return '<p align="center"/>' if type == 'strikethrough'
    inner_text = node.inner_html.strip
    replace = case
              when type == 'bold|italic|smallcaps'
                "<emph type=\"10\"><emph type=\"6\">#{inner_text}</emph></emph>"
              when type == 'bold|italic'
                "<emph type=\"10\">#{inner_text}</emph>"
              when type == 'bold|superscript'
                "<emph type=\"1\"><emph type=\"7\">#{inner_text}</emph></emph>"
              when type == 'italic|underline'
                "<emph type=\"2\"><emph type=\"4\">#{inner_text}</emph></emph>"
              when type == 'italic|smallcaps'
                "<emph type=\"2\"><emph type=\"6\">#{inner_text}</emph></emph>"
              when type == 'bold'
                "<emph type=\"1\">#{inner_text}</emph>"
              when /italic/.match(type)
                "<emph type=\"2\">#{inner_text}</emph>"
              when type == 'underline'
                "<emph type=\"4\">#{inner_text}</emph>"
              when /smallcaps/.match(type)
                "<emph type=\"6\">#{inner_text}</emph>"
              when /superscript/.match(type)
                "<emph type=\"7\">#{inner_text}</emph>"
              when type == 'subscript'
                "<emph type=\"8\">#{inner_text}</emph>"
              when type == 'allcaps'
                inner_text.upcase
              else
                inner_text
              end
    node.add_next_sibling(replace)
    node.remove
  end
end
