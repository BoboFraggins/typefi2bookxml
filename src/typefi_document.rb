class TypefiDocument
  def initialize(file)
    begin
      @doc = Nokogiri::XML(File.open(file)) do |config|
        config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
      end
      @front = Nokogiri::XML::Node.new 'front', @doc
      @front.inner_html = '<titlegrp><title/></titlegrp><authgrp></authgrp>'
      @body = Nokogiri::XML::Node.new 'body', @doc
      @back = Nokogiri::XML::Node.new 'back', @doc
      @doc.remove_namespaces!
    rescue Nokogiri::XML::SyntaxError
      raise Typefi2bookxmlError.new('Cannot parse input file. XML is not well formed.')
    end
  end

  def parse!
    @doc.xpath('//content').each do |content|
      ContentTag.process_node(content)
      content.children.first.add_previous_sibling(@back)
      content.children.first.add_previous_sibling(@body)
      content.children.first.add_previous_sibling(@front)
    end
    chapter_index = 0
    @doc.xpath('//section').each_with_index do |section, section_index|
      type = section.get_attribute('type').downcase
      front_matter = !!/frontmatter/.match(type)
      chapter_index += 1 unless front_matter
      section.children.each { |node| parse_node!(node, section_index + 1, chapter_index, front_matter) }
      chapter_index = chapter_index + SectionTag.process_node(section, section_index + 1, chapter_index, front_matter)
    end
    i = 1
    [['//supmatl', @front], ['//chapter', @body], ['//notes', @back]].each do |part|
      @doc.xpath(part[0]).each do |tag|
        title = tag.get_attribute('title')
        title ||= tag.xpath('title')[0].inner_text.gsub("\n", '') if tag.xpath('title').length > 0
        Nokogiri::XML::Comment.new(tag, "leaf#{sprintf('%03d', i)}: page:#{i} (#{i}) bkmk:#{i} ([#{title}])").parent = part[1]
        tag.remove_attribute 'title'
        tag.parent = part[1]
        i += 1
      end
    end
  end

  def contents
    PostProcessor.cleanup(@doc.to_xhtml)
  end

  def parse_node!(node, section_index, chapter_index, front_matter)
    node.children.each { |child| parse_node!(child, section_index, chapter_index, front_matter) }
    case node.name.downcase
    when 'c'
      CTag.process_node(node, section_index, chapter_index, front_matter)
    when 'p'
      PTag.process_node(node, section_index, chapter_index, front_matter)
    when 'style'
      StyleTag.process_node(node, section_index, chapter_index, front_matter)
    when 'context'
      ContextTag.process_node(node, section_index, chapter_index, front_matter)
    when 'image'
      ImageTag.process_node(node, section_index, chapter_index, front_matter)
    when 'anchor'
      AnchorTag.process_node(node, section_index, chapter_index, front_matter)
    when 'xref'
      XRefTag.process_node(node, section_index, chapter_index, front_matter)
    when 'link'
      LinkTag.process_node(node, section_index, chapter_index, front_matter)
    when 'l', 's', 't', 'endanchor', 'fieldset'
      node.remove
    when 'text'
    else
      puts "Warning: Unrecognized '#{node.name}' tag"
    end
  end
end
