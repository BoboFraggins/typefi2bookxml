class CTag
  def self.process_node(node, section_index, chapter_index, front_matter)
    type = node.get_attribute('type').downcase.gsub(' ', '')
    inner_text = node.inner_html.strip
    replace = case type
              when 'bold', 'glossaryterm'
                "<emph type=\"1\">#{inner_text}</emph>"
              when 'italic', 'ital'
                "<emph type=\"2\">#{inner_text}</emph>"
              when 'roman'
                "<emph type=\"3\">#{inner_text}</emph>"
              when 'smallcaps', 'sc', 'fraction', 'opening'
                "<emph type=\"6\">#{inner_text}</emph>"
              when 'footnote'
                if front_matter
                  "<fnoteref rids=\"fn_#{section_index}_#{inner_text}\">#{inner_text}</fnoteref>"
                else
                  "<fnoteref rids=\"fn_#{section_index}_#{inner_text}\">#{inner_text}</fnoteref></p><p><footnote id=\"fn_#{section_index}_#{inner_text}\"><p>3. footnote reference</p></footnote>"
                end
              when 'enr'
                "<fnoteref rids=\"fnr_#{section_index}_#{inner_text}\">#{inner_text}</fnoteref>"
             when 'runinhed1', 'runinhed2'
               "<span class=\"#{type}\">#{inner_text}</span>"
              when /xchar/.match(type)
                "<span class=\"#{type}\">#{inner_text}</span>"
              else
                inner_text
              end
    node.add_next_sibling(replace)
    node.remove
  end
end
