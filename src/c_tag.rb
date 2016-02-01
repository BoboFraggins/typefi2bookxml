class CTag
  def self.process_node(node, chapter_index, front_matter)
    type = node.get_attribute('type').downcase.gsub(' ', '')
    inner_text = node.inner_html.strip
    replace = case type
              when 'bold'
                "<emph type=\"1\">#{inner_text}</emph>"
              when 'italic'
                "<emph type=\"2\">#{inner_text}</emph>"
              when 'roman'
                "<emph type=\"3\">#{inner_text}</emph>"
              when 'smallcaps', 'sc', 'fraction', 'opening'
                "<emph type=\"6\">#{inner_text}</emph>"
             #  when 'footnote'
             #    if front_matter
             #      "<fnoteref rids=\"fn_#{chapter_index}_#{inner_text}\">#{inner_text}</fnoteref>"
             #    else
             #      "<fnoteref rids=\"fn_#{chapter_index}_#{inner_text}\">#{inner_text}</fnoteref></p><p><footnote id=\"fn_#{chapter_index}_#{inner_text}\"><p>3. footnote reference</p></footnote>"
             #    end
             #  when 'enr'
             #    "<p align=\"center\"><fnoteref rids=\"fnr_#{chapter_index}_#{inner_text}\">#{inner_text}</fnoteref></p>"
             #  when 'url'
             #    ""
              else
                inner_text
              end
    node.name = 'p'
    node.set_attribute('align', (front_matter ? 'center' : 'left'))
    node.remove_attribute 'type'
    node.inner_html = replace
  end
end
