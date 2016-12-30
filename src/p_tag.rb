class PTag
  def self.process_node(node, section_index, chapter_index, front_matter)
    raw_type = node.get_attribute('type')
    type = raw_type.downcase.gsub(' ', '')
    inner_text = node.inner_html.strip
    replace = front_matter ? front_matter_replace(node, raw_type, type, inner_text) : body_replace(node, raw_type, type, inner_text, section_index)
    node.add_next_sibling(replace) if replace
    node.remove
  end

  def self.front_matter_replace(node, raw_type, type, inner_text)
    return "<p align='center'>#{inner_text}</p>" if /copyright/.match(type)
    case type
    when 'cn', 'ct', '-ct', 'en', 'et', 'extt', 'pt', 'alsobyhead', 'mattertitle'
      "<title>#{inner_text}</title>"
    when 'toc_chaptitle', 'toc_ahed', 'toc_bhed'
      "<p align=\"left\">#{inner_text}</p>"
    when 'halftitle', 'alsoby', 'seriestitle', 'booktitle', 'booksubtitle', 'author', 'imprint', 'copyright', 'dedication'
      "<p align=\"center\">#{inner_text}</p>"
    when 'signature'
      "<p align=\"right\">#{inner_text}</p>"
    when 'copyrightspace'
      "<break type=\"space\" /><p align=\"center\">#{inner_text}</p>"
    when 'epigraph1', 'epigraph1source'
      "<bq><p>#{inner_text}</p></bq>"
    else
      if (node.parent.xpath('(p)[1]')[0] == node) && (type == 'normal')
        "<p align='left'>#{inner_text}</p>"
      else
        "<p>#{inner_text}</p>"
      end
    end
  end

  def self.body_replace(node, raw_type, type, inner_text, section_index)
    return "<p align='left'>#{inner_text}</p>" if node.previous_element && node.previous_element.name.downcase == 'break'
    return "<p align='left'>#{inner_text}</p>" if (node.parent.xpath('(p)[1]')[0] == node) && (type == 'normal')
    return "<p>#{inner_text}</p>" if ['bib', 'normal', 'text', '[basicparagraph]', 'chapopenertext'].include?(type)
    return extract(node, raw_type, type, inner_text, section_index) if type.start_with?('extract')
    return dialog(node, raw_type, type, inner_text, section_index) if type.start_with?('dialog')
    return verse(node, raw_type, type, inner_text, section_index) if type.start_with?('verse')
    return list(node, raw_type, type, inner_text, section_index) if type.start_with?('bulletedlist') || type.start_with?('numlist') || type.start_with?('unmarkedlist')
    case
    when ['bl1_s', 'bl1_m', 'bl1_e'].include?(type)
      "<break/><list type=\"4\"><item><p align=\"left\">#{inner_text}</p></item></list><break/>"
    when ['cap1', 'caption', 'v_s', 'v_m', 'v_e'].include?(type)
      "<bq><p align=\"left\"><emph type=\"2\">#{inner_text}</emph></p></bq>"
    when ['dlg1_s', 'dlg1_m', 'dlg1_e', 'ep1', 'v', 'v_epigraph'].include?(type)
      "<bq><p align=\"left\">#{inner_text}</p></bq>"
    when 'ep1s_2' == type
      "<bq><p align=\"center\"><emph type=\"2\">#{inner_text}</emph></p></bq>"
    when 'ep1_2' == type
      "<bq><p align=\"center\">#{inner_text}</p></bq>"
    when 'ext2' == type
      "<bq><p>#{inner_text}</p></bq>"
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
    when ['references', 'endnote', 'glossary'].include?(type)
      "<p align=\"hang\">#{inner_text}</p>"
    when 'gl' == type
      "<break/><p align=\"left\">#{inner_text}</p><break/>"
    when ['ext1_s', 'ext1s'].include?(type)
      "<bq><p align=\"left\">#{inner_text}</p></bq>"
    when ['ext1_s+bold', 'ext1_m+bold', 'ext1_e+bold'].include?(type)
      "<bq><p align=\"left\"><emph type=\"1\">#{inner_text}</emph></p></bq>"
    when /enottxt\(cont/.match(type) || /ext1/.match(type)
      "<bq><p>#{inner_text}</p></bq"
    when ['annotationtext', 'ack', 'body(first)', 'bodyfirst', 'indexalpha', 'placehld',
         'tb_fl', 'th_fl', 'txacknowledgments', 'partopenertextfirst', 'partopenertext', 'chapopenertextfirst', 'bio'].include?(type)
      "<p align=\"left\">#{inner_text}</p>"
    when /xpara/.match(type) || /copyright/.match(type) || /enottxt/.match(type) || /tabletext/.match(type) || /textfirst/.match(type) || /chapopenertextfirst/.match(type) || /sidebartextfirst/.match(type)
      "<p align=\"left\">#{inner_text}</p>"
    when ['ca', 'letterauthor'].include?(type)
      "<p align=\"right\">#{inner_text}</p>"
    when ['diaryorn', 'th_ctr'].include?(type)
      "<p align=\"center\">#{inner_text}</p>"
    when ['cst', '-et', 'chapsubtitle', 'chapauthor', 'sidebarsubtitle'].include?(type)
      "<subtitle>#{inner_text}</subtitle>"
    when ['cn', 'ct', '-ct', 'en', 'et', 'extt', 'pt', 'mattertitle', 'chapnumber', 'chaptitle', 'sidebartitle', 'biohed'].include?(type)
      "<title>#{inner_text}</title>"
    when ['partnumber', 'parttitle'].include?(type)
      "<title class=\"parttitle\">#{inner_text}</title>"
    when /spcbrk2/.match(type)
      '<break type="graphic"/>'
    when '1/2ls' == type
      "<break type=\"space\"/><bq><p>#{inner_text}</p></bq>"
    when ['1ls', 'spacebreak2', 'halflinespace', 'linespace'].include?(type) || /spcbrk/.match(type)
      '<break type="space"/>'
    when ['epigraph2', 'epigraph2source'].include?(type)
      "<bq><p class=\"#{raw_type}\">#{inner_text}</p></bq>"
    when /xpara/.match(type)
      "<p class=\"#{type}\">#{inner_text}</p>"
    when ['je-keyline', 'je-placeholder', 'je-imageid'].include?(type)
      "<h1>#{inner_text}</h1>"
    when ['ahed'].include?(type)
      "<h2>#{inner_text}</h2>"
    when ['bhed'].include?(type)
      "<h3>#{inner_text}</h3>"
    when ['ched'].include?(type)
      "<h4>#{inner_text}</h4>"
    when ['dhed'].include?(type)
      "<h5>#{inner_text}</h5>"
    when ['ehed', 'fhed'].include?(type)
      "<h6>#{inner_text}</h6>"
    when ['caption1', 'caption2'].include?(type)
      "<caption>#{inner_text}</caption>"
    when ['credit'].include?(type)
      "<source>#{inner_text}</source>"
    when ['index1', 'index2', 'index3'].include?(type)
      "<p class=\"#{type}\">#{inner_text}</p>"
    else
      "<p class=\"#{raw_type}\">#{inner_text}</p>"
    end
  end

  def self.extract(node, raw_type, type, inner_text, section_index)
    return "<p align='left'>#{inner_text}</p>" if type == 'extractattrib'
    matches = /extract([0-9]+)(.*)/.match(type)
    case
    when matches[2] == '_standalone'
      "<break type=\"space\" /><bq class=\"extract#{matches[1]}\"><p align=\"left\">#{inner_text}</p></bq><break type=\"space\" />"
    when matches[2] == '_first'
      "<break type=\"space\" /><bq class=\"extract#{matches[1]}\"><p align=\"left\">#{inner_text}</p></bq>"
    when matches[2] == '_last'
      "<bq class=\"extract#{matches[1]}\"><p>#{inner_text}</p></bq><break type=\"space\" />"
    else
      "<bq class=\"extract#{matches[1]}\"><p>#{inner_text}</p></bq>"
    end
  end

  def self.dialog(node, raw_type, type, inner_text, section_index)
    matches = /dialog([0-9]+)(.*)/.match(type)
    case
    when matches[2] == '_first'
      "<break type=\"space\" /><bq class=\"dialog#{matches[1]}\"><p align=\"hang\">#{inner_text}</p></bq>"
    when matches[2] == '_last'
      "<bq class=\"dialog#{matches[1]}\"><p align=\"hang\">#{inner_text}</p></bq><break type=\"space\" />"
    else
      "<bq class=\"dialog#{matches[1]}\"><p align=\"hang\">#{inner_text}</p></bq>"
    end
  end

  def self.verse(node, raw_type, type, inner_text, section_index)
    matches = /verse(.*)/.match(type)
    case
    when matches[2] == '_standalone'
      "<break type=\"space\" /><bq><p align=\"hang\">#{inner_text}</p></bq><break type=\"space\" />"
    when matches[2] == '_first'
      "<break type=\"space\" /><bq><p align=\"hang\">#{inner_text}</p></bq>"
    when matches[2] == '_last'
      "<bq><p align=\"hang\">#{inner_text}</p></bq><break type=\"space\" />"
    when matches[2] == 'stanza'
      "<break type=\"space\" />"
    else
      "<bq><p align=\"hang\">#{inner_text}</p></bq>"
    end
  end

  def self.list(node, raw_type, type, inner_text, section_index)
    matches = /([a-z]+?)list([0-9]+)(.*)/.match(type)
    list_type = '4'
    list_type = '1' if matches[1] == 'num'
    list_type = '6' if matches[1] == 'unmarked'
    if matches[3] == '_first'
      "<list type=\"#{list_type}\" class=\"#{matches[1]}#{matches[2]}\"><item><p>#{inner_text}</p></item></list>"
    else
      "<item><p>#{inner_text}</p></item>"
    end
  end
end
