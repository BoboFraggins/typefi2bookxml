class PTag
  def self.process_node(node, chapter_index, front_matter)
    type = node.get_attribute('type').downcase.gsub(' ', '')
    inner_text = node.inner_html.strip
    replace = front_matter ? front_matter_replace(type, inner_text) : body_replace(type, inner_text, chapter_index)
    node.add_next_sibling(replace) if replace
    node.remove
  end

  def self.front_matter_replace(type, inner_text)
    case type
    when 'cn', 'ct', '-ct', 'en', 'et', 'extt', 'pt'
      "<title>#{inner_text}</title>"
    else
      "<p align=\"center\">#{inner_text}</p>"
    end
  end

  def self.body_replace(type, inner_text, chapter_index)
    return "<p>#{inner_text}</p>" if type == 'bib'
    case type
    when 'bl1_s', 'bl1_m', 'bl1_e'
      "<break/><list type=\"4\"><item><p align=\"left\">#{inner_text}</p></item></list><break/>"
    when 'cap1', 'caption', 'v_s', 'v_m', 'v_e'
      "<bq><p align=\"left\"><emph type=\"2\">#{inner_text}</emph></p></bq>"
    when 'dlg1_s', 'dlg1_m', 'dlg1_e', 'ep1', 'index2', 'index3', 'v', 'v_epigraph'
      "<bq><p align=\"left\">#{inner_text}</p></bq>"
    when 'ep1s_2'
      "<bq><p align=\"center\"><emph type=\"2\">#{inner_text}</emph></p></bq>"
    when 'ep1_2'
      "<bq><p align=\"center\">#{inner_text}</p></bq>"
    when 'ext2'
      "<bq><p><bq><p>#{inner_text}</p></bq></p></bq>"
    # when 'figureholder'
    #   "<fig id=\"???\" scale=\"1\"/>"
    # when 'fnottxt', 'footnotetext'
    #   "<p><footnote id=\"fn_#{chapter_index}_1\"><p>#{inner_text}</p></footnote></p>"
    when 'heading1run-in'
      "<p align=\"center\"><emph type=\"1\"><emph type=\"6\">#{inner_text}</emph></emph></p>"
    when 'headingb'
      "<p align=\"left\"><emph type=\"2\">#{inner_text}</emph></p>"
    when 'headingc'
      "<p align=\"left\"><emph type=\"6\">#{inner_text}</emph></p>"
    when 'ep1s', 'ep1s_prologue', 'ep1schapteropener'
      "<bq><p align=\"right\">#{inner_text}</p></bq>"
    when 'heading1', 'heading1withrun-in', 'headingnotes'
      "<p align=\"center\"><emph type=\"6\">#{inner_text}</emph></p>"
    when 'heading2', 'heading3', 'hn', 'pt_txt'
      "<p align=\"center\"><emph type=\"2\">#{inner_text}</emph></p>"
    when 'nl1_s', 'nl1_m', 'nl1_e'
      "<break/><list type=\"1\"><item><p align=\"left\">#{inner_text}</p></item></list><break/>"
    when 'ul1_s', 'ul1_m', 'ul1_e'
      "<break/><list type=\"6\"><item><p align=\"left\">#{inner_text}</p></item></list><break/>"
    when 'headinga', 'tablehead', 'vparthead'
      "<p align=\"left\"><emph type=\"1\">#{inner_text}</emph></p>"
    when 'GL'
      "<break/><p align=\"left\">#{inner_text}</p><break/>"
    when 'ext1_s', 'ext1s'
      "<bq><p align=\"left\">#{inner_text}</p></bq>"
    when 'ext1_s+bold', 'ext1_m+bold', 'ext1_e+bold'
      "<bq><p align=\"left\"><emph type=\"1\">#{inner_text}</emph></p></bq>"
    when /enottxt\(cont/.match(type), /ext1/.match(type)
      "<bq><p>#{inner_text}</p></bq"
    when 'annotationtext', 'ack', 'body(first)', 'bodyfirst', 'indexalpha', 'index1', 'normal', 'placehld',
         'tb_fl', 'th_fl', 'txacknowledgments', /xpara/.match(type), /copyright/.match(type), /enottxt/.match(type),
         /tabletext/.match(type)
      "<p align=\"left\">#{inner_text}</p>"
    when 'ca', 'letterauthor'
      "<p align=\"right\">#{inner_text}</p>"
    when 'diaryorn', 'th_ctr'
      "<p align=\"center\">#{inner_text}</p>"
    when 'cst', '-et'
      "<subtitle>#{inner_text}</subtitle>"
    when 'cn', 'ct', '-ct', 'en', 'et', 'extt', 'pt'
      "<title>#{inner_text}</title>"
    when /spcbrk2/.match(type)
      '<break type="graphic"/>'
    when '1/2ls'
      "<break type=\"space\"/><bq><p>#{inner_text}</p></bq>"
    when '1ls', /spcbrk/.match(type)
      '<break type="space"/>'
    end
  end
end
