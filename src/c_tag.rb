class CTag
  def self.replacement_str(type, inner_text, chapter_index, front_matter)
    type = type.downcase.gsub(' ', '')
    inner_text = inner_text.trim
    replace_text = case type
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
                   when 'enr'
                     "<p align=\"center\"><fnoteref rids=\"fnr_#{chapter_index}_#{inner_text}\">#{inner_text}</fnoteref></p>"
                  #  when 'url'
                  #    ""
                   else
                     inner_text
                   end
    "<p align=\"#{front_matter ? 'center' : 'left'}\">#{replace_text}</p>"
  end
end
