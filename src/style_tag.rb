class SectionTag
  def self.replacement_str(type, inner_text, _, front_matter)
    type = type.to_lower.gsub(' ', '')
    return '<p align="center"/>' if type == 'strikethrough'
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
              when /italic/.match(text)
                "<emph type=\"2\">#{inner_text}</emph>"
              when 'underline'
                "<emph type=\"4\">#{inner_text}</emph>"
              when /smallcaps/.match(text)
                "<emph type=\"6\">#{inner_text}</emph>"
              when /superscript/.match(text)
                "<emph type=\"7\">#{inner_text}</emph>"
              when 'subscript'
                "<emph type=\"8\">#{inner_text}</emph>"
              when 'allcaps'
                inner_text.to_upper
              else
                inner_text
              end
    "<p align=\"#{front_matter ? 'center' : 'left'}\">#{replace}</p>"
  end
end
