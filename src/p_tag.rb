class PTag
  def self.process_node(node, section_index, chapter_index, front_matter)
    type = node.get_attribute('type').downcase.gsub(' ', '')
    inner_text = node.inner_html.strip
    replace = front_matter ? front_matter_replace(node, type, inner_text) : body_replace(type, inner_text, section_index)
    node.add_next_sibling(replace) if replace
    node.remove
  end

  def self.front_matter_replace(node, type, inner_text)
    case type
    when 'cn', 'ct', '-ct', 'en', 'et', 'extt', 'pt'
      "<title>#{inner_text}</title>"
    else
      if node.parent.xpath('(p)[1]')[0] == node
        "<p align='left'>#{inner_text}</p>"
      else
        "<p>#{inner_text}</p>"
      end
    end
  end

  def self.body_replace(type, inner_text, section_index)
    return "<p>#{inner_text}</p>" if type == 'bib' || type == 'normal'
    case
    when ['bl1_s', 'bl1_m', 'bl1_e'].include?(type)
      "<break/><list type=\"4\"><item><p align=\"left\">#{inner_text}</p></item></list><break/>"
    when ['cap1', 'caption', 'v_s', 'v_m', 'v_e'].include?(type)
      "<bq><p align=\"left\"><emph type=\"2\">#{inner_text}</emph></p></bq>"
    when ['dlg1_s', 'dlg1_m', 'dlg1_e', 'ep1', 'index2', 'index3', 'v', 'v_epigraph'].include?(type)
      "<bq><p align=\"left\">#{inner_text}</p></bq>"
    when 'ep1s_2' == type
      "<bq><p align=\"center\"><emph type=\"2\">#{inner_text}</emph></p></bq>"
    when 'ep1_2' == type
      "<bq><p align=\"center\">#{inner_text}</p></bq>"
    when 'ext2' == type
      "<bq><p><bq><p>#{inner_text}</p></bq></p></bq>"
    # when 'figureholder' == type
    #   "<fig id=\"???\" scale=\"1\"/>"
    when ['fnottxt', 'footnotetext'].include?(type)
      "<p><footnote id=\"fn_#{section_index}_1\"><p>#{inner_text}</p></footnote></p>"
    when 'heading1run-in' == type
      "<p align=\"center\"><emph type=\"1\"><emph type=\"6\">#{inner_text}</emph></emph></p>"
    when 'headingb' == type
      "<p align=\"left\"><emph type=\"2\">#{inner_text}</emph></p>"
    when 'headingc' == type
      "<p align=\"left\"><emph type=\"6\">#{inner_text}</emph></p>"
    when ['ep1s', 'ep1s_prologue', 'ep1schapteropener'].include?(type)
      "<bq><p align=\"right\">#{inner_text}</p></bq>"
    when ['heading1', 'heading1withrun-in', 'headingnotes'].include?(type)
      "<p align=\"center\"><emph type=\"6\">#{inner_text}</emph></p>"
    when ['heading2', 'heading3', 'hn', 'pt_txt'].include?(type)
      "<p align=\"center\"><emph type=\"2\">#{inner_text}</emph></p>"
    when ['nl1_s', 'nl1_m', 'nl1_e'].include?(type)
      "<break/><list type=\"1\"><item><p align=\"left\">#{inner_text}</p></item></list><break/>"
    when ['ul1_s', 'ul1_m', 'ul1_e'].include?(type)
      "<break/><list type=\"6\"><item><p align=\"left\">#{inner_text}</p></item></list><break/>"
    when ['headinga', 'tablehead', 'vparthead'].include?(type)
      "<p align=\"left\"><emph type=\"1\">#{inner_text}</emph></p>"
    when 'GL' == type
      "<break/><p align=\"left\">#{inner_text}</p><break/>"
    when ['ext1_s', 'ext1s'].include?(type)
      "<bq><p align=\"left\">#{inner_text}</p></bq>"
    when ['ext1_s+bold', 'ext1_m+bold', 'ext1_e+bold'].include?(type)
      "<bq><p align=\"left\"><emph type=\"1\">#{inner_text}</emph></p></bq>"
    when /enottxt\(cont/.match(type) || /ext1/.match(type)
      "<bq><p>#{inner_text}</p></bq"
    when ['annotationtext', 'ack', 'body(first)', 'bodyfirst', 'indexalpha', 'index1', 'placehld',
         'tb_fl', 'th_fl', 'txacknowledgments'].include?(type)
      "<p align=\"left\">#{inner_text}</p>"
    when /xpara/.match(type) || /copyright/.match(type) || /enottxt/.match(type) || /tabletext/.match(type)
      "<p align=\"left\">#{inner_text}</p>"
    when ['ca', 'letterauthor'].include?(type)
      "<p align=\"right\">#{inner_text}</p>"
    when ['diaryorn', 'th_ctr'].include?(type)
      "<p align=\"center\">#{inner_text}</p>"
    when ['cst', '-et'].include?(type)
      "<subtitle>#{inner_text}</subtitle>"
    when ['cn', 'ct', '-ct', 'en', 'et', 'extt', 'pt'].include?(type)
      "<title>#{inner_text}</title>"
    when /spcbrk2/.match(type)
      '<break type="graphic"/>'
    when '1/2ls' == type
      "<break type=\"space\"/><bq><p>#{inner_text}</p></bq>"
    when '1ls' == type || /spcbrk/.match(type)
      '<break type="space"/>'
    end
  end
end
